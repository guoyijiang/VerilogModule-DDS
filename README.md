## 概述
DDS（Direct Digital Synthesizer） ，直接数字频率合成器，用于合成任意周期波形，例中是用的正弦表，若需要修改波形按”sinxx65536.dat“格式修改波形文件即可。

* dds.v是单路输出的正常dds模块
* dds2DA输出两路正交信号，可用作AM/FM等模块解调

## 参数

* f_clk ：使能时钟ClkEn 	决定了dds的最大输出频率

* phase：波形相位，位宽是PHASE_W，影响调频精度

* sintable：正弦表，深度位宽是TABLE_AW ，可以比phase位宽小，影响波形还原精度和资源占用
		  长度位宽是DATA_W ，影响波形精度（锯齿）
* FreqWord：频率控制字，控制输出信号周期
      			