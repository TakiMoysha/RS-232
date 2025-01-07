https://www.youtube.com/watch?v=H2GyAIYwZbw
Я буду использовать GTKWave и GHDL
Скачай GHDL и GTKWave, распаковать их в удобное место и добавить вс системные переменные
tb = (test bench)

Test:
ghdl -a *.vhdl

ghdl -a *_tb.vhdl
ghdl -e *_tb
ghdl -r *_tb

ghdl -r *_tb --vcd=*.vcd
