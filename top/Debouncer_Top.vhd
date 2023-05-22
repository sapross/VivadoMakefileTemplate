library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.all;

library work;
  use work.ExamplePackage.all;

entity DEBOUNCER_TOP is
  port (
    SYS_CLK_I : in    std_logic;
    BTNC_I    : in    std_logic_vector(0 downto 0);
    LED_O     : out   std_logic_vector(0 downto 0)
  );
end entity DEBOUNCER_TOP;

architecture STRUCTURAL of DEBOUNCER_TOP is

  signal reset    : std_logic;            -- Debounced reset signal.

begin

  BUTTONDEBOUNCER : entity work.debouncer
    generic map (
      TIMEOUT_CYCLES => 50
    )
    port map (
      CLK_I    => SYS_CLK_I,
      RST_I    => '0',
      INPUT_I  => BNTC_I(0),
      OUTPUT_O => LED_O(0)
    );

end architecture STRUCTURAL;
