--
-- Copyright 2013 Marko Zec, University of Zagreb
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.
--

-- $Id$

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library xp2;
use xp2.components.all;


entity bram is
    generic(
	C_mem_size: integer
    );
    port(
	clk: in std_logic;
	imem_addr_strobe: in std_logic;
	imem_data_ready: out std_logic;
	imem_addr: in std_logic_vector(31 downto 2);
	imem_data_out: out std_logic_vector(31 downto 0);
	dmem_addr_strobe: in std_logic;
	dmem_data_ready: out std_logic;
	dmem_write: in std_logic;
	dmem_byte_sel: in std_logic_vector(3 downto 0);
	dmem_addr: in std_logic_vector(31 downto 2);
	dmem_data_in: in std_logic_vector(31 downto 0);
	dmem_data_out: out std_logic_vector(31 downto 0)
    );
end bram;

architecture Behavioral of bram is
    signal dmem_data_read, dmem_write_out: std_logic_vector(31 downto 0);
    signal dmem_bram_cs, we: std_logic;
    signal byte_en: std_logic_vector(3 downto 0);
    signal addr: std_logic_vector(10 downto 2);
begin
	
    dmem_data_out <= dmem_data_read; -- shut up compiler errors
    dmem_write_out <= dmem_data_in;
    dmem_bram_cs <= dmem_addr_strobe;
    dmem_data_ready <= '1';

    G_2k:
    if C_mem_size = 2 generate
    we <= dmem_addr_strobe and dmem_write;
    byte_en <= "1111" when we = '0' else dmem_byte_sel;
    addr <= dmem_addr(10 downto 2) when dmem_addr_strobe = '1'
      else imem_addr(10 downto 2);
    imem_data_ready <= not dmem_addr_strobe;
    imem_data_out <= dmem_data_read;
    ram_2_0: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 18, DATA_WIDTH_A => 18,
	INITVAL_00 => "0x048031FEFE158021FE4015EBF00014048020000304EBD1FEE8000001F02101000000030781D10010",
	INITVAL_01 => "0x048070005512228002F2068891000C078041000F048050040001800000560000004021158031FEF0",
	INITVAL_02 => "0x02A8D0001D0480D000AA1222C002F31222B0000202A07000211222500003122261FEFF1222A00000",
	INITVAL_03 => "0x0284000015056E2000020062B1F021000051940002AF800019002C60F02104818020000000A0E400",
	INITVAL_04 => "0x0480A0002004889000010780C000200780400010048651FC00018000005604804004000001F03600",
	INITVAL_05 => "0x022000000B06268000011000B1FE210000000000020A00000F002890502A140061FE110000C06643",
	INITVAL_06 => "0x0180000076000000000001800000DF04A8C0000104A8C1FEFF028EA00009100071FE200000000000",
	INITVAL_07 => "0x06AA2100000780D1000F0000C0664302A801FEEC04A8C1FEFF000000000001000000400000000000",
	INITVAL_08 => "0x028401FEFE17840000000480208000026A000004000441D024078050001007804100000004001021",
	INITVAL_09 => "0x100021FE2104EBD00018006E00000811EBF00014006A51D0250002000008000001F021048421FEFC",
	INITVAL_0a => "0x15EB00001404EBD1FEE006082000FF006E000008100041FE200000000000020601FEFD0604300001",
	INITVAL_0b => "0x018000027E0000004021000A011021018000028515EB10001815EBF0001C00000040210008010021",
	INITVAL_0c => "0x00400050210000004021018000027E00010054020000004021018000027E0001005802048050000B",
	INITVAL_0d => "0x078051000F11EB00001411EBF0001C04805000FF018000027E00000040210000004021018000027E",
	INITVAL_0e => "0x15EB70002C04EBD1FEC804EBD000200100000262068A510000000000402111EB1000180042006021",
	INITVAL_0f => "0x15EB10001415EB20001815EBE0003015EBF0003415EB30001C15EB40002015EB50002415EB600028",
	INITVAL_10 => "0x018000004F000100248204817000A004816000B104815000B004814000A1048130009115EB000010",
	INITVAL_11 => "0x0284600003048060009002045000280480500081020800000B05844000920205300039140021FE11",
	INITVAL_12 => "0x02054000360481E0000401000000AF0001002482028471FEF3004001202101000000860480700080",
	INITVAL_13 => "0x020550003B000001102101000000C5000001E021028571FEEA0000000000022A0000050584D000A2",
	INITVAL_14 => "0x11EB50002411EB60002811EB70002C11EBE00030004000202111EBF00034028561FEE40000000000",
	INITVAL_15 => "0x018000004F04EBD00038006E00000811EB00001011EB10001411EB20001811EB30001C11EB400020",
	INITVAL_16 => "0x0480C00004004200B02100010024820100000087000501002102EC01FEFC04EDE1FEFF0001010400",
	INITVAL_17 => "0x02A801FEF804A8C1FEFF140081FE20000000000002A401FEFD0622A00004100091FE210000B08C03",
	INITVAL_18 => "0x018000004F0001002482026D21FEC100400110210100000086000100248201000000870000B0B400",
	INITVAL_19 => "0x0000002021000001102104EDE0000101000000C50042211021142C200000006D00E0210000000000",
	INITVAL_1a => "0x140181FE20000000000002EE01FEFD0663F00004100191FE21102F800000000500F021020521FEB5",
	INITVAL_1b => "0x0000008021000100248201000000870040004021018000028E048420000101000000D00043811021",
	INITVAL_1c => "0x048180000D0480F000530480E000030480D000010780C010000780B0403E0780A066660000006021",
	INITVAL_1d => "0x0000303403140031FE200000000000028E01FEFD060A700004100051FE2104A430140D0000019021",
	INITVAL_1e => "0x04805000FF028601FEF304A630C63201000000EA048191FEFF000000000002A20000040007909025",
	INITVAL_1f => "0x02620000020004C19024000000000008002090000000000000008610001C0480700002048031FEFF",
	INITVAL_20 => "0x00000000000222000003006290902A06639000FF06049000FF00002198C304804000FF0000004021",
	INITVAL_21 => "0x0000000000026201FEEB0609900001100041FE21140041FE1107084000F0070840000F010000020B",
	INITVAL_22 => "0x010000020B00000030210000002021048191FEFF0288F00005048891FEF60086100013100041FE20",
	INITVAL_23 => "0x100021FE21000000202102A201FEDC0508900020020981FECC000000000002099000460000604403",
	INITVAL_24 => "0x0000209200026200000505A3900004140041FE2001000000FA0000000000028401FEFD0604200004",
	INITVAL_25 => "0x0100000234048821FED002840000030508200061048070000201000000FC048031FEFF04805000FF",
	INITVAL_26 => "0x0286D0001104863000010008902025048841FEC9000490202502E20000030509900041048841FEE0",
	INITVAL_27 => "0x000001F021002041D024078050001007804100000504900004020800000905E2400003048591FEF9",
	INITVAL_28 => "0x010000024200002050400000000000022201FEFD000000202101000000FA006A51D0250020000008",
	INITVAL_29 => "0x000000000002A201FEAB000E20702101000002420000202040050A9000060286E00004048A500005",
	INITVAL_2a => "0x026201FEA2000600502101000000FA0004008021000400602102A0000002000A31902A0286500006",
	INITVAL_2b => "0x048C60000101000000FA140C2000000000000000022201FE9E000670902A020801FEA00606400001",
	INITVAL_2c => "0x020601FEFD06283002001188C1FE30140821FE3004802000FF020C0000190000000000006E000008",
	INITVAL_2d => "0x060CB00003140871FE300000C09C00020C00000D0000A0840204807000FF048C61FEFF000000A021",
	INITVAL_2e => "0x0000000000022A01FEFD0628D002001188C1FE30048A500004158AA00000002280A02502A6000003",
	INITVAL_2f => "0x118821FE30140851FE300000000000006E000008158A4000000022804025048C61FEFF010000026B",
	INITVAL_30 => "0x140821FE30048020008004884000010000000000006E00000806042000FF020601FEFD0604300200",
	INITVAL_31 => "0x15EB00001404EBD1FEE00000000000006E0000080000000000020A01FEFD0606500200118831FE30",
	INITVAL_32 => "0x01800002BA04805006E8000110480200000000000801110000000801002115EB10001815EBF0001C",
	INITVAL_33 => "0x0484308441078020000F0004011021048A50000101800002E500040040210001105E420608401EFF",
	INITVAL_34 => "0x01800002E500004044800004004021048050000A01800002E50040004021028C000004004030602A",
	INITVAL_35 => "0x02A2000004004080902A048E808441078070000F004200502101800002E5000020448004805006E8",
	INITVAL_36 => "0x11EB00001411EB10001811EBF0001C1480C1FE220024B0C0210000C0B0C00000C0A0400484C00001",
	INITVAL_37 => "0x000440202100000000000206000002060A300001020A000007000000202104EBD00020006E000008",
	INITVAL_38 => "0x000050A02B0204000008060C2000010000000000006E000008000040404001000002BB0000505042",
	INITVAL_39 => "0x000A40802B000050A02B0008704023000A3050230008704026000A3050260000407EC30000503EC3",
	INITVAL_3a => "0x02A20000030000A0A04001000002CF00005050400000000000030A00000A0000002021022000000C",
	INITVAL_3b => "0x060C600002000850902B02A401FEF900005050420000A0A0420004A0202500085040230000000000",
	INITVAL_3c => "0x0000000000000000602101000002C50000000000006E00000800080020210000000000020C000002",
	INITVAL_3d => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
	INITVAL_3e => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
	INITVAL_3f => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
    )
    port map (
	DIA0 => dmem_write_out(0), DIA1 => dmem_write_out(1),
	DIA2 => dmem_write_out(2), DIA3 => dmem_write_out(3),
	DIA4 => dmem_write_out(4), DIA5 => dmem_write_out(5),
	DIA6 => dmem_write_out(6), DIA7 => dmem_write_out(7),
	DIA8 => '0',
	DIA9 => dmem_write_out(8), DIA10 => dmem_write_out(9),
	DIA11 => dmem_write_out(10), DIA12 => dmem_write_out(11),
	DIA13 => dmem_write_out(12), DIA14 => dmem_write_out(13),
	DIA15 => dmem_write_out(14), DIA16 => dmem_write_out(15),
	DIA17 => '0', 
	DOA0 => dmem_data_read(0), DOA1 => dmem_data_read(1),
	DOA2 => dmem_data_read(2), DOA3 => dmem_data_read(3),
	DOA4 => dmem_data_read(4), DOA5 => dmem_data_read(5),
	DOA6 => dmem_data_read(6), DOA7 => dmem_data_read(7),
	DOA8 => open,
	DOA9 => dmem_data_read(8), DOA10 => dmem_data_read(9),
	DOA11 => dmem_data_read(10), DOA12 => dmem_data_read(11),
	DOA13 => dmem_data_read(12), DOA14 => dmem_data_read(13),
	DOA15 => dmem_data_read(14), DOA16 => dmem_data_read(15),
	DOA17 => open, 
	ADA0 => byte_en(0), ADA1 => byte_en(1),
	ADA2 => '0', ADA3 => '0', ADA4 => '0',
	ADA5 => addr(2), ADA6 => addr(3),
	ADA7 => addr(4), ADA8 => addr(5),
	ADA9 => addr(6), ADA10 => addr(7),
	ADA11 => addr(8), ADA12 => addr(9),
	ADA13 => addr(10),
	CEA => '1', CLKA => not clk, WEA => we,
	CSA0 => '0', CSA1 => '0', CSA2 => '0', RSTA => '0',
	DIB0 => dmem_write_out(16), DIB1 => dmem_write_out(17),
	DIB2 => dmem_write_out(18), DIB3 => dmem_write_out(19),
	DIB4 => dmem_write_out(20), DIB5 => dmem_write_out(21),
	DIB6 => dmem_write_out(22), DIB7 => dmem_write_out(23),
	DIB8 => '0',
	DIB9 => dmem_write_out(24), DIB10 => dmem_write_out(25),
	DIB11 => dmem_write_out(26), DIB12 => dmem_write_out(27),
	DIB13 => dmem_write_out(28), DIB14 => dmem_write_out(29),
	DIB15 => dmem_write_out(30), DIB16 => dmem_write_out(31),
	DIB17 => '0', 
	DOB0 => dmem_data_read(16), DOB1 => dmem_data_read(17),
	DOB2 => dmem_data_read(18), DOB3 => dmem_data_read(19),
	DOB4 => dmem_data_read(20), DOB5 => dmem_data_read(21),
	DOB6 => dmem_data_read(22), DOB7 => dmem_data_read(23),
	DOB8 => open,
	DOB9 => dmem_data_read(24), DOB10 => dmem_data_read(25),
	DOB11 => dmem_data_read(26), DOB12 => dmem_data_read(27),
	DOB13 => dmem_data_read(28), DOB14 => dmem_data_read(29),
	DOB15 => dmem_data_read(30), DOB16 => dmem_data_read(31),
	DOB17 => open, 
	ADB0 => byte_en(2), ADB1 => byte_en(3),
	ADB2 => '0', ADB3 => '0', ADB4 => '1',
	ADB5 => addr(2), ADB6 => addr(3),
	ADB7 => addr(4), ADB8 => addr(5),
	ADB9 => addr(6), ADB10 => addr(7),
	ADB11 => addr(8), ADB12 => addr(9),
	ADB13 => addr(10),
	CEB => '1', CLKB => not clk, WEB => we,
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );
    end generate; -- 2k

    G_16k:
    if C_mem_size = 16 generate
    imem_data_ready <= '1';
    ram_16_0: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x01E3C1E0000C0F11F200162101F4130020000C000A410122001B432026F00A4CF00C101C04310230",
	INITVAL_01 => "0x090041804819002002811E8CF1C21E022E203C2B1C21511811080F8000D1030840B01C1C00408001",
	INITVAL_02 => "0x11E001A81308227038F01F080090C0090C00284016251140520C8F20626006081164911E40100210",
	INITVAL_03 => "0x048000182F1E62A1E0450600D082D11A63101C61024711C201000D40201502215020101E4110C470",
	INITVAL_04 => "0x0280009239022590A61008031058FF00A40140D4022C0180631621F0AC3001611020FB006AF1E6F1",
	INITVAL_05 => "0x0000800AFB01A00080530600D05EF11A0001F208034001D401042A1024A60161200C450400D03458",
	INITVAL_06 => "0x020210E208090C2020010941F02A080A01A0A24A03E110A22F150200028C0800801A000001011ED0",
	INITVAL_07 => "0x00000000000000000000000000000000250102020569204A30060F00141C176330CC3317010100B2"
    )
    port map (
	DIA0 => dmem_write_out(0), DIA1 => dmem_write_out(1),
	DIA2 => dmem_write_out(2), DIA3 => dmem_write_out(3),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(0), DOA1 => dmem_data_read(1),
	DOA2 => dmem_data_read(2), DOA3 => dmem_data_read(3),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(0), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(0), DOB1 => imem_data_out(1),
	DOB2 => imem_data_out(2), DOB3 => imem_data_out(3),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_1: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x0004E1E0400E0D01E02000020004140402100A000202002400034F0040F00BE0000A2F1E8101C401",
	INITVAL_01 => "0x022330242205826004120021F0E4270447004E000E4280222203CF0040F0042010402F1E00004202",
	INITVAL_02 => "0x1FE201E0200048805EF0086010221204423046E0064C21C00A060A81E4880122801231090AB17491",
	INITVAL_03 => "0x004000020F1FE3E1E0020040F0040200A000066205082100D2040F00402B0440C04020090C211080",
	INITVAL_04 => "0x044100000F0202C0404E07A0601EFF000021E0F0044D2180400042F01E1201C0203E000002F1F8F2",
	INITVAL_05 => "0x06600004F601E03000200060001EF21E0331E20001E00124A0144F20402001424080000880F05E20",
	INITVAL_06 => "0x040000042002212058400044005C8E1D0201C402080201C44F17C000041103C0001E030700001EF0",
	INITVAL_07 => "0x000000000000000000000000000000004C000400004F408420008C40002004422044CC04000008B4"
    )
    port map (
	DIA0 => dmem_write_out(4), DIA1 => dmem_write_out(5),
	DIA2 => dmem_write_out(6), DIA3 => dmem_write_out(7),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(4), DOA1 => dmem_data_read(5),
	DOA2 => dmem_data_read(6), DOA3 => dmem_data_read(7),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(0), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(4), DOB1 => imem_data_out(5),
	DOB2 => imem_data_out(6), DOB3 => imem_data_out(7),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_2: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x0003F1E000000001E0F0000F0010F3000001C02B0008A0100200010000F0002000400F1FE001F000",
	INITVAL_01 => "0x000000000001E010000000000020011001A002C0020810000001E001E0F01E0001008F1E00010008",
	INITVAL_02 => "0x1FEF01E0F60102001EF2000000000000000000F0010001E000000021E000000000000F0040000000",
	INITVAL_03 => "0x010080000F01E301E00815E0F01EA8000001003000400020081E0F01E08F0100010000004F80040A",
	INITVAL_04 => "0x110000000F0000F0000F03E00000F01200F000F01E0F01E0020300F01E0F01E0F1E0010008001800",
	INITVAL_05 => "0x1FE00000F101E1F0000001EE0040F01E2FF00000000001F0F01F0000008001E81000000300F00080",
	INITVAL_06 => "0x00000000000000F010000102010223024000200004080020FF026400000001E0001E1F1E000000F1",
	INITVAL_07 => "0x0000000000000000000000000000000001000000010F800000000180000000008010FF0000000018"
    )
    port map (
	DIA0 => dmem_write_out(8), DIA1 => dmem_write_out(9),
	DIA2 => dmem_write_out(10), DIA3 => dmem_write_out(11),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(8), DOA1 => dmem_data_read(9),
	DOA2 => dmem_data_read(10), DOA3 => dmem_data_read(11),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(1), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(8), DOB1 => imem_data_out(9),
	DOB2 => imem_data_out(10), DOB3 => imem_data_out(11),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_3: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x1103F1E000000001E0F0000F0004F3000001E001000FC00E1700000000F0000880002F1FE001FE08",
	INITVAL_01 => "0x000000000001E001040310000004200440204020004800002801E001E0F01E0001C0FF1E0401C080",
	INITVAL_02 => "0x1FEF01E0F400A1011EF8000000000000000020F00100F1E000000011F200000000000F0020000000",
	INITVAL_03 => "0x018040000F01E601E00403E0F01E0C000000043308202000081E0F01E07F0300010070002F800205",
	INITVAL_04 => "0x1FC080000F0001F0200F01E00000F00800F000F01E2F01E0020021F01E0F01E0F1E0000004001802",
	INITVAL_05 => "0x1FE00004F001E0F0005001E40080F51E0FF00000000001E8F01E404060C001E30020000040F020E0",
	INITVAL_06 => "0x02000002000000F0CA50008400402000420004030808000420000201100001E0001E0F1E000000F0",
	INITVAL_07 => "0x0000000000000000000000000000000060000200008F20A22000A020001008A22044310A00000402"
    )
    port map (
	DIA0 => dmem_write_out(12), DIA1 => dmem_write_out(13),
	DIA2 => dmem_write_out(14), DIA3 => dmem_write_out(15),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(12), DOA1 => dmem_data_read(13),
	DOA2 => dmem_data_read(14), DOA3 => dmem_data_read(15),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(1), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(12), DOB1 => imem_data_out(13),
	DOB2 => imem_data_out(14), DOB3 => imem_data_out(15),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_4: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x05AC0180000000C19470010B00126C152C40A04F004B510C8A1BACB0EA6A0F0940A003064F21A00D",
	INITVAL_01 => "0x024EF068560FAD00A0100A0F50000000000000050000003E0001A200800305A0F0A0020002008A40",
	INITVAL_02 => "0x018800149B18000000E001A00024340AC7E01E600A0000E00D09C000E0070CC5500832000760A830",
	INITVAL_03 => "0x01802002730A03012009066000EA3011EED196A000000004081000F13002000E004400000200000B",
	INITVAL_04 => "0x00854120491A69412094004020E03504094000020400910096000091F21400094088400009912440",
	INITVAL_05 => "0x04A0009060000DC0B48016EC014E60006C2040000C02000E04000000003500020052E50040000050",
	INITVAL_06 => "0x08003000D0002FC178CC01087000250080500003064050001400A100201F01A00000530444000403",
	INITVAL_07 => "0x00000000000000000000000000000000000000000CA0515450014050000008A730E6450A02000805"
    )
    port map (
	DIA0 => dmem_write_out(16), DIA1 => dmem_write_out(17),
	DIA2 => dmem_write_out(18), DIA3 => dmem_write_out(19),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(16), DOA1 => dmem_data_read(17),
	DOA2 => dmem_data_read(18), DOA3 => dmem_data_read(19),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(2), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(16), DOB1 => imem_data_out(17),
	DOB2 => imem_data_out(18), DOB3 => imem_data_out(19),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_5: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x14008100000000811C0000C0015000010000C00109C201F81010022004220048000000000B016001",
	INITVAL_01 => "0x176BB176BB176B0140B2016B0000000000100010000A0176081768E00064016EB144040880A08004",
	INITVAL_02 => "0x1100008400004100B8D1016EB176BB176BB016500A0000A0A40A201080000804010850002110221B",
	INITVAL_03 => "0x0480000C0000C60020270000E1404002000000000020000803020E303E55000D0058D0002D000200",
	INITVAL_04 => "0x00000090250CC8808498010480000000430000440002812090000011106000490010800042308000",
	INITVAL_05 => "0x1100E144C001488154261900C000C00D0880180E180C004C8604C04080A6004E00146A00002000A0",
	INITVAL_06 => "0x0806A140BE176B008004040E00400000040000C00804A0081800010030BB1760E01468100801C864",
	INITVAL_07 => "0x000000000000000000000000000000000001D00C190400088004000014001408A11400008C01C000"
    )
    port map (
	DIA0 => dmem_write_out(20), DIA1 => dmem_write_out(21),
	DIA2 => dmem_write_out(22), DIA3 => dmem_write_out(23),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(20), DOA1 => dmem_data_read(21),
	DOA2 => dmem_data_read(22), DOA3 => dmem_data_read(23),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(2), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(20), DOB1 => imem_data_out(21),
	DOB2 => imem_data_out(22), DOB3 => imem_data_out(23),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_6: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x0B8050A080180C50A8000220000200088CC09840096300A2400A8110A2110824C0980C098F40E08C",
	INITVAL_01 => "0x1FEFF1FEFF1EE78080F219EF41800C040C0018041800C1FE001EE030000000E3F0600409843018C0",
	INITVAL_02 => "0x0AA000A2000840800E7018E3F1FEFF1FEFF05E40000800801C00880084840880401800180440884F",
	INITVAL_03 => "0x06000008440885808050000040005008844198C00008218882000730020000078042301803210080",
	INITVAL_04 => "0x002CC100F40880400E841084809044006D0100400005800000100040884000600010880023300040",
	INITVAL_05 => "0x18003182480021C098150000000840002C00800309000020000608000A0400A08010441000101031",
	INITVAL_06 => "0x00000000731FEF4020040A44C058041800418442098041800018800000FF1EE030000C0084006000",
	INITVAL_07 => "0x000000000000000000000000000000000800600000050000000A0800100100000000000000006080"
    )
    port map (
	DIA0 => dmem_write_out(24), DIA1 => dmem_write_out(25),
	DIA2 => dmem_write_out(26), DIA3 => dmem_write_out(27),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(24), DOA1 => dmem_data_read(25),
	DOA2 => dmem_data_read(26), DOA3 => dmem_data_read(27),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(3), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(24), DOB1 => imem_data_out(25),
	DOB2 => imem_data_out(26), DOB3 => imem_data_out(27),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );

    ram_16_7: DP16KB
    generic map (
	-- CSDECODE_B => "000", CSDECODE_A => "000",
	WRITEMODE_B => "NORMAL", WRITEMODE_A => "NORMAL",
	GSR => "ENABLED", RESETMODE => "SYNC", 
	REGMODE_B => "NOREG", REGMODE_A => "NOREG",
	DATA_WIDTH_B => 4, DATA_WIDTH_A => 4,
	INITVAL_00 => "0x0660104000000020428002680020A0044330402002400020200249903299052330400A054A204003",
	INITVAL_01 => "0x154AA154AA1442006080070820000000000000020000015400144301001310408000020362100630",
	INITVAL_02 => "0x024A00268004000002200040811088110880101002000020120240002002024120241A000220442A",
	INITVAL_03 => "0x02004000220422004010014010702004422066300000000400140131100100020014000001000000",
	INITVAL_04 => "0x0003304222024020022200412040220022A000131001202010000020240800238146300020306020",
	INITVAL_05 => "0x1140014020002380540107401004200268A04200040A002013020000020100200004120000100000",
	INITVAL_06 => "0x00013020201108A0000202023000020000200010046020000300400080AA14400002381442000613",
	INITVAL_07 => "0x00000000000000000000000000000000000000010601000000020000020100000000000023000000"
    )
    port map (
	DIA0 => dmem_write_out(28), DIA1 => dmem_write_out(29),
	DIA2 => dmem_write_out(30), DIA3 => dmem_write_out(31),
	DIA4 => '0', DIA5 => '0', DIA6 => '0', DIA7 => '0',
	DIA8 => '0', DIA9 => '0', DIA10 => '0', DIA11 => '0',
	DIA12 => '0', DIA13 => '0', DIA14 => '0', DIA15 => '0',
	DIA16 => '0', DIA17 => '0', 
	DOA0 => dmem_data_read(28), DOA1 => dmem_data_read(29),
	DOA2 => dmem_data_read(30), DOA3 => dmem_data_read(31),
	DOA4 => open, DOA5 => open, DOA6 => open, DOA7 => open,
	DOA8 => open, DOA9 => open, DOA10 => open, DOA11 => open,
	DOA12 => open, DOA13 => open, DOA14 => open, DOA15 => open,
	DOA16 => open, DOA17 => open, 
	ADA0 => '0', ADA1 => '0',
	ADA2 => dmem_addr(2), ADA3 => dmem_addr(3),
	ADA4 => dmem_addr(4), ADA5 => dmem_addr(5),
	ADA6 => dmem_addr(6), ADA7 => dmem_addr(7),
	ADA8 => dmem_addr(8), ADA9 => dmem_addr(9),
	ADA10 => dmem_addr(10), ADA11 => dmem_addr(11),
	ADA12 => dmem_addr(12), ADA13 => dmem_addr(13),
	CEA => dmem_bram_cs, CLKA => not clk, WEA => dmem_write,
	CSA0 => not dmem_byte_sel(3), CSA1 => '0', CSA2 => '0',
	RSTA => '0',
	DIB0 => '0', DIB1 => '0', DIB2 => '0', DIB3 => '0', 
	DIB4 => '0', DIB5 => '0', DIB6 => '0', DIB7 => '0', 
	DIB8 => '0', DIB9 => '0', DIB10 => '0', DIB11 => '0', 
	DIB12 => '0', DIB13 => '0', DIB14 => '0', DIB15 => '0', 
	DIB16 => '0', DIB17 => '0',
	DOB0 => imem_data_out(28), DOB1 => imem_data_out(29),
	DOB2 => imem_data_out(30), DOB3 => imem_data_out(31),
	DOB4 => open, DOB5 => open, DOB6 => open, DOB7 => open,
	DOB8 => open, DOB9 => open, DOB10 => open, DOB11 => open,
	DOB12 => open, DOB13 => open, DOB14 => open, DOB15 => open,
	DOB16 => open, DOB17 => open, 
	ADB0 => '0', ADB1 => '0',
	ADB2 => imem_addr(2), ADB3 => imem_addr(3),
	ADB4 => imem_addr(4), ADB5 => imem_addr(5),
	ADB6 => imem_addr(6), ADB7 => imem_addr(7),
	ADB8 => imem_addr(8), ADB9 => imem_addr(9),
	ADB10 => imem_addr(10), ADB11 => imem_addr(11),
	ADB12 => imem_addr(12), ADB13 => imem_addr(13),
	CEB => imem_addr_strobe, CLKB => not clk, WEB => '0', 
	CSB0 => '0', CSB1 => '0', CSB2 => '0', RSTB => '0'
    );
    end generate; -- 16k

end Behavioral;
