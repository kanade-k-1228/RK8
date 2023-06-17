# RK16 CPU : FPGA implementation

TinyFPGA-BX (ICE40LP8K)

## ROM

On board flash ROM: (AT25DF081A)[https://www.renesas.com/jp/ja/products/memory-logic/non-volatile-memory/spi-nor-flash/at25df081a-8mbit-27v-minimum-spi-serial-flash-memory]

### Map

| Addr                  |                         |
| --------------------- | ----------------------- |
| 0x00_00A0 : 0x02_8000 | bootloader              |
| 0x02_8000 : 0x05_0000 | userimage               |
| 0x05_0000 : 0x09_0000 | text (0xFFFF x 4 byte)  |
| 0x09_0000 : 0x10_0000 | consts (0x07_0000 byte) |
