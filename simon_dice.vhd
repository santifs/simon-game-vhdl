----------------------------------------------------------------------------------
-- Company: University of Seville
-- Engineer: Santiago Fernandez Scagliusi
-- 
-- Create Date:    19:48:39 05/25/2019 
-- Design Name:    Main
-- Module Name:    simon_dice - Behavioral 
-- Project Name:   Simon Game
-- Target Devices: Nexys 4 DDR
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simon_dice is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           btnu : in  STD_LOGIC;
           btnd : in  STD_LOGIC;
           btnr : in  STD_LOGIC;
           btnl : in  STD_LOGIC;
           btnc : in  STD_LOGIC;
           inicio_juego : in  STD_LOGIC;
           fila : out  STD_LOGIC_VECTOR (7 downto 0);
           col : out  STD_LOGIC_VECTOR (7 downto 0);
           led_r : out  STD_LOGIC;
           led_g : out  STD_LOGIC;
           led_b : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (7 downto 0);
           ca : out  STD_LOGIC;
           cb : out  STD_LOGIC;
           cc : out  STD_LOGIC;
           cd : out  STD_LOGIC;
           ce : out  STD_LOGIC;
           cf : out  STD_LOGIC;
           cg : out  STD_LOGIC);
end simon_dice;

architecture Behavioral of simon_dice is
   
   COMPONENT lfsr16
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		secuencia : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ram_datos
	PORT(
		clk : IN std_logic;
		wea : IN std_logic;
		ena : IN std_logic;
		enb : IN std_logic;
		addra : IN std_logic_vector(6 downto 0);
		addrb : IN std_logic_vector(6 downto 0);
		dia : IN std_logic_vector(2 downto 0);          
		doa : OUT std_logic_vector(2 downto 0);
		dob : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Rom_simon
	PORT(
		addr_fila : IN std_logic_vector(5 downto 0);          
		data_fila : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
   
	COMPONENT bcd7seg
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ud : IN std_logic_vector(3 downto 0);
		dec : IN std_logic_vector(3 downto 0);
		cen : IN std_logic_vector(3 downto 0);          
		an : OUT std_logic_vector(7 downto 0);
		ca : OUT std_logic;
		cb : OUT std_logic;
		cc : OUT std_logic;
		cd : OUT std_logic;
		ce : OUT std_logic;
		cf : OUT std_logic;
		cg : OUT std_logic
		);
	END COMPONENT;
   
	COMPONENT bin2bcd
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		nivel : IN std_logic_vector(6 downto 0);          
		ud : OUT std_logic_vector(3 downto 0);
		dec : OUT std_logic_vector(3 downto 0);
		cen : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
   COMPONENT debounce_cod
	PORT(
		clk : IN std_logic;
		btnu : IN std_logic;
		btnd : IN std_logic;
		btnr : IN std_logic;
		btnl : IN std_logic;
		btnc : IN std_logic;          
		cod : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	signal cont : unsigned(16 downto 0);
   signal clk_mostrar : unsigned(25 downto 0);                        -- Tiempo de muestra de figuras por la matriz de LEDs
   signal clk_apagar : unsigned(24 downto 0);								 -- Tiempo de apagado de la matriz de LEDs
	signal secuencia : std_logic_vector(15 downto 0);						 -- Secuencia generada por el lfsr_16
	signal sec_cargada : std_logic;								 				 -- Bandera que indica secuencia cargada en la RAM
	signal sec_cont : unsigned(3 downto 0) := "0000";						 -- Contador de espera de 8 ciclos entre cada dato de secuencia
	signal sec_dato : unsigned(6 downto 0) := "0000000";					 -- Contador de cantidad de datos cargados (de 0 a 127)
	signal wea, ena, enb : std_logic;											 -- Señales de habilitacion y escritura de la RAM
   signal addra, addrb : std_logic_vector(6 downto 0) := "0000000";   -- Entrada de direccion de la RAM
   signal dia, doa, dob : std_logic_vector(2 downto 0);					 -- Datos de entrada y salida de la RAM
   signal addr_fila : std_logic_vector(5 downto 0) := "000000";       -- Entrada de direccion de la ROM
   signal data_fila : std_logic_vector(7 downto 0) := "00000000";     -- Dato de salida de la ROM
   type tipo_estado is (inicio, mostrar, apagar, espera_boton, boton_pulsado, comparar, error);  -- Estados del proceso principal
   signal estado : tipo_estado;
   signal cod: std_logic_vector(2 downto 0) := "000";       			 -- Salida de debounce que señala que boton se ha pulsado
   signal copia: std_logic_vector(2 downto 0) := "000";       			 -- Copia el valor de cod para analizar en otro momento
	signal ud, dec, cen: std_logic_vector(3 downto 0) := "0000";
   signal nivel: std_logic_vector(6 downto 0);  							 -- Señal que marca el nivel actual
	signal nivel_aux: unsigned(6 downto 0) := "0000000";  				 -- Señal auxiliar para convertir nivel en unsigned
   signal enciende_fila : std_logic_vector(2 downto 0); 					 -- 3 LSB que se incrementaran para encender la fila correspondiente y para recorrer la ROM
   signal i : unsigned(6 downto 0); 											 -- Indice para recorrer toda la secuencia almacenada en la RAM
	signal cargar : std_logic;														 -- Bandera para activar la carga de la secuencia

begin

   Inst_lfsr16: lfsr16 PORT MAP(
		clk => clk,
		reset => reset,
		secuencia => secuencia
	);
		
	Inst_ram_datos: ram_datos PORT MAP(
		clk => clk,
		wea => wea,
		ena => ena,
		enb => enb,
		addra => addra,
		addrb => addrb,
		dia => dia,
		doa => doa,
		dob => dob
	);
	
	Inst_Rom_simon: Rom_simon PORT MAP(
		addr_fila => addr_fila,
		data_fila => data_fila
	);
	Inst_bcd7seg: bcd7seg PORT MAP(
		clk => clk ,
		reset => reset ,
		ud => ud ,
		dec => dec ,
		cen => cen ,
		an => an ,
		ca => ca ,
		cb => cb ,
		cc => cc ,
		cd => cd ,
		ce => ce ,
		cf => cf ,
		cg => cg
	);
	Inst_bin2bcd: bin2bcd PORT MAP(
		clk => clk ,
		reset => reset ,
		nivel => nivel ,
		ud => ud ,
		dec => dec ,
		cen => cen 
	);
	Inst_debounce_cod: debounce_cod PORT MAP(
		clk => clk ,
		btnu => btnu ,
		btnd => btnd ,
		btnr => btnr ,
		btnl => btnl ,
		btnc => btnc ,
		cod => cod
	);
	
	contador: process (clk, reset)  -- Contador para encender las filas de la matriz de LEDs con una frecuencia mas lenta
   begin
      if reset = '1' then
         cont <= (others => '0');
      elsif rising_edge(clk) then
         cont <= cont + 1;
      end if;
   end process;

   enciende_fila <= std_logic_vector(cont(16 downto 14));
     
   addr_fila <= (dob & enciende_fila) when estado = mostrar else       -- 3 MSB indican la figura a mostrar + 3 LSB que se incrementan continuamente
                 ("101" & enciende_fila) when estado = error else      -- Si esta en estado error, muestra la cruz
                 ("111" & enciende_fila);                              -- Si no esta en el estado de mostrar apaga matriz (111 = codigo de apagar)
   col <= data_fila;                                                   -- En cada momento se iluminara la columna que diga la ROM por su salida data_fila
   fila <= "00000001" when enciende_fila = "000" else                  -- Se encendera la fila correspondiente de forma continua
           "00000010" when enciende_fila = "001" else
           "00000100" when enciende_fila = "010" else
           "00001000" when enciende_fila = "011" else
           "00010000" when enciende_fila = "100" else
           "00100000" when enciende_fila = "101" else
           "01000000" when enciende_fila = "110" else
           "10000000" when enciende_fila = "111";
	
   nivel <= std_logic_vector(nivel_aux);
   addrb <= std_logic_vector(i);             				-- Obtiene por la salida dob la figura correspondiente al nivel i
   
	P_carga_secuencia:process(clk, reset)                 -- Guarda la secuencia generada por lsfr16 en la RAM
   begin
      if (reset = '1') then
         sec_dato <= (others => '0');
			   sec_cont <= (others => '0');
			   sec_cargada <= '0';
      elsif rising_edge(clk) then
         if cargar = '1' then                            -- Juego iniciado, cargar secuencia
            if sec_dato < 127 then                        -- Secuencia incompleta, seguir
               if sec_cont = 8 then                          -- Pasados 8 ciclos
                  sec_cont <= (others => '0');                 -- Reinicia contador
                  if (secuencia(15 downto 13) < "101") then    -- Codigo valido (4 flechas y 1 circulo = 5 figuras)
                     wea <= '1';                                  -- Configura puerto A de RAM como escritura
                     ena <= '1';                                  -- Enable puerto A RAM
                     addra <= std_logic_vector(sec_dato);         -- Señala fila a escribir en RAM
                     dia <= secuencia(15 downto 13);              -- Data Input A. Escribe codigo en RAM
                     sec_dato <= sec_dato + 1;                    -- Incrementa contador de datos cargados
                  end if;
               else
                  sec_cont <= sec_cont + 1;                  -- Todavia no pasaron 8 ciclos
               end if;
            else                                         -- Secuencia completa guardada (128 datos)
   			   wea <= '0';                                   -- Desactiva escritura puerto A RAM
               ena <= '0';                                   -- Deshabilita puerto A RAM
               sec_cargada <= '1';                           -- Secuencia cargada, continuar juego
            end if;
         end if;
      end if;
   end process;
        
   Pprincipal: process (clk, reset)
   begin
      if reset = '1' then
         cargar <= '0';
         i <= (others => '0');
         nivel_aux <= (others => '0');
         clk_mostrar <= (others => '0');
         clk_apagar <= (others => '0');
         estado <= inicio;
         led_b <= '0';
         led_g <= '0';
         led_r <= '0';         
      elsif rising_edge(clk) then
         case estado is
            when inicio =>                         -- Inicializacion. Carga secuencia en RAM
               if inicio_juego = '1' then             -- Switch de inicio de juego activado
                  cargar <= '1';                         -- Bandera para cargar secuencia (proceso P1_secuencia)
                  if sec_cargada = '1' then              -- Secuencia cargada completamente
                     cargar <= '0';                       -- Desactiva bandera de carga
                     estado <= mostrar;                   -- Salta a estado de pedir dato
                  end if;
               end if;
            when mostrar =>                        -- Carga figura de la RAM y la muestra por la matriz de LEDs
               led_b <= '0';                         -- Apaga el LED azul por si viene del estado comparar
               if i <= nivel_aux then                    -- Se han cargado todas las figuras hasta el nivel actual?
                  enb <= '1';                           -- No. Activar lectura del puerto B de la RAM
                  if clk_mostrar < 40000000 then        -- Ha pasado 1 segundo?
                     clk_mostrar <= clk_mostrar + 1;       -- No. Incrementa contador
                  else
                     clk_mostrar <= (others => '0');       -- Si. Reinicia contador
                     i <= i + 1;                           -- Incrementa indice
                     estado <= apagar;                     -- Salta a estado apagar
                  end if;
               else
                  i <= (others => '0');                 -- Mostradas todas las figuras. Limpia indice
                  estado <= espera_boton;                   -- Ahora comparara los botones pulsados por el jugador
               end if;
            when apagar =>                         -- El apagado se hace de forma concurrente (Ver asignacion de addr_fila)
               if clk_apagar < 20000000 then          -- Han pasado 0,5 segundos?        
                  clk_apagar <= clk_apagar + 1;          -- No. Incrementa contador
               else                                      
                  clk_apagar <= (others => '0');         -- Si. Reinicia contador
                  estado <= mostrar;                     -- Vuelve a estado mostrar para obtener otra figura
               end if;  
            when espera_boton =>
               led_b <= '1';                       -- Enciende LED azul para indicar que el jugador puede empezar a pulsar los botones
               if cod /= "110" then                -- Se ha pulsado algun boton? (Cod = 110 es ningun boton pulsado)
                  copia <= cod;                       -- Si. Copia el valor del pulsador
                  estado <= boton_pulsado;
               end if;                                -- No. Permanece en este estado hasta que se pulse
            when boton_pulsado =>
               if cod = "110" then                 -- Se ha soltado el pulsador?
                  estado <= comparar;                 -- Si. Entonces compara valor
               end if;						               -- No. Permanece en este estado hasta que se suelte
            when comparar =>                       -- Compara los botones pulsados con la figura correspondiente al nivel. Compara solo 1 cada vez que entra en el estado
					if (copia = dob) then                    -- Pulsador correcto?
					   if i < nivel_aux then
						   i <= i + 1;                            -- Si. Incrementa indice
							estado <= espera_boton;                -- Vuelve para esperar siguiente boton a comparar
						else
						   led_b <= '0';                          -- Secuencia introducida correctamente
							led_g <= '1';                          -- Enciende LED verde
							nivel_aux <= nivel_aux + 1;            -- Sube de nivel
							i <= (others => '0');                  -- Reinicia indice
							estado <= mostrar;                     -- Vuelve a mostrar toda la secuencia + una figura adicional
						end if;
					else
					   estado <= error;                       -- No. Salta a estado de error
					end if;
            when error =>                          -- Pulsador incorrecto. Juego terminado
               led_b <= '0';									-- Apaga LED azul
               led_g <= '0';									-- Apaga LED verde
               led_r <= '1';                          -- Enciende LED rojo
               i <= (others => '0');                  -- Reinicia indice
         end case;
      end if;
   end process;    

end Behavioral;

