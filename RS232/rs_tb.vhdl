
LIBRARY ieee;                                                
USE ieee.std_logic_1164.all;                                 
 
ENTITY Uart_vhd_tst IS 
END Uart_vhd_tst; 
ARCHITECTURE Uart_arch OF Uart_vhd_tst IS 
-- constants    
constant clk_period : time := 20.00 ns;

constant bod_period : time := 8680 ns;  
constant rx_data0 : STD_LOGIC_VECTOR(7 DOWNTO 0):= X"55";   
constant rx_data1 : STD_LOGIC_VECTOR(7 DOWNTO 0):= X"AA";   
constant rx_data2 : STD_LOGIC_VECTOR(7 DOWNTO 0):= X"02";   
                                               
-- signals                                                    
SIGNAL clk : STD_LOGIC; 
SIGNAL reset : STD_LOGIC; 
SIGNAL din : STD_LOGIC_VECTOR(7 DOWNTO 0); 
SIGNAL tx_en : STD_LOGIC; 
SIGNAL tx : STD_LOGIC; 
SIGNAL tx_done_tick : STD_LOGIC; 
SIGNAL rx : STD_LOGIC; 
SIGNAL rx_done_tick : STD_LOGIC; 
SIGNAL dout : STD_LOGIC_VECTOR(7 DOWNTO 0); 
 
subtype tresh_test is std_logic_vector(7 downto 0); 
type memory_tresh_test  is array(7 downto 0) of tresh_test; 
signal s_tresh_test : memory_tresh_test; 
 
COMPONENT Uart 
    PORT ( 
    clk : IN STD_LOGIC; 
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
    reset : IN STD_LOGIC; 
    rx : IN STD_LOGIC; 
    tx : OUT STD_LOGIC; 
    rx_done_tick : OUT STD_LOGIC; 
    tx_done_tick : OUT STD_LOGIC; 
    tx_en : IN STD_LOGIC 
    ); 
END COMPONENT; 
BEGIN 
    i1 : Uart 
    PORT MAP ( 
    clk => clk, 
    dout => dout, 
    din => din, 
    reset => reset, 
    rx => rx, 
    tx => tx, 
    rx_done_tick => rx_done_tick, 
    tx_done_tick => tx_done_tick, 
    tx_en => tx_en 
    ); 
 
 
-- системный сброс 
init : PROCESS                                                
BEGIN                                                         
reset <= '0', '1' after 2*clk_period; 
WAIT;                                                        
END PROCESS init;                                            
 
-- тактовая 
always : PROCESS                                               
BEGIN  
clk <= '0'; 
wait for clk_period/2;  
clk <= '1'; 
wait for clk_period/2;  
END PROCESS always;  
 
-- процесс на входе com 
comrx : process  
begin 
 
    rx <= '1'; 
 
    tx_en <= '0'; 
    wait for 5us; 
    -- данные на передатчик 
    tx_en <= '1'; 
    din <= X"55"; 
    wait for bod_period*9; 
    din <= X"AA"; 
    wait for bod_period*9; 
    din <= X"01"; 
    wait for bod_period*9; 
    tx_en <= '0'; 
 
    wait for bod_period*9; 
    wait for 10us; 
 
    -- данные на вход приемника 
    for j in 0 to 2 loop 
        if j = 0 then  
            s_tresh_test(j) <= rx_data0; 
        elsif j = 1 then  
            s_tresh_test(j) <= rx_data1; 
        elsif j = 2 then  
            s_tresh_test(j) <= rx_data2; 
        end if; 
        -- старт бит 
        rx <= '0'; 
        wait for bod_period*2; 
        -- передача байта  
        for i in 0 to 7 loop 
        rx <= s_tresh_test(j)(i); wait for bod_period*2; 
        end loop; 
        -- стоп бит 
        rx <= '1';  
        wait for bod_period*2; 
    end loop; 
 
    wait; 
 
end process comrx; 
                                          
END Uart_arch; 