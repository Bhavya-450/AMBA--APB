# AMBA--APB  
## Introduction of AMBA ***:

AMBA is an open specification that specifies a strategy on the management of the functional blocks that sort system on chip (SoC) architecture.
The AMBA specification standard is used for designing high-level embedded microcontrollers.
AMBA’s major objective is to provide technology independence and to encourage modular system design. Furthermore, it strongly encourages the development of reusable peripheral devices while minimizing silicon infrastructure. 

Today,  AMBA is widely used on a range of ASIC and SoC parts including applications processors used in modern portable mobile devices like smartphones.
AMBA was introduced by ARM in 1996. The first AMBA buses were the Advanced System Bus (ASB) and the Advanced Peripheral Bus (APB).

In its second version, AMBA 2 in 1999, ARM added AMBA High-performance Bus (AHB) that is a single clock-edge protocol.
In 2003, ARM introduced the third generation, AMBA 3, including Advanced eXtensible Interface (AXI) to reach even higher performance interconnect and the Advanced Trace Bus (ATB) as part of the CoreSight on-chip debug and trace solution.

In 2010, the AMBA 4 specifications were introduced starting with AMBA 4 AXI4, then
in 2011, extending system-wide coherency with AMBA 4 AXI Coherency Extensions (ACE).
In 2013, the AMBA 5 Coherent Hub Interface (CHI) specification was introduced, with a re-designed high-speed transport layer and features designed to reduce congestion.

The APB protocol is a low-cost interface, optimized for minimal power consumption and reduced interface
complexity. The APB interface is not pipelined and is a simple, synchronous protocol. Every transfer takes at least
two cycles to complete.

The APB interface is designed for accessing the programmable control registers of peripheral devices. APB
peripherals are typically connected to the main memory system using an APB bridge. For example, a bridge from
AXI to APB could be used to connect a number of APB peripherals to an AXI memory system. 

APB transfers are initiated by an APB bridge. APB bridges can also be referred to as a Requester. A peripheral
interface responds to requests. APB peripherals can also be referred to as a Completer. This specification will use
Requester and Completer

## TYPES OF AMBA bus*** :
1. Five interfaces are defined within the AMBA specification: 
2. Advanced system bus (ASB)
3. Advanced peripheral bus (APB)
4. Advanced high-performance bus (AHB)
5. Advanced extensible interface (AXI)
6. Advanced trace bus (ATB).

## APB -BLOCK DIAGRAM ***:
   
![APB Block Diagram](img2.jpg)

## APB - SLGS :
**PCLK Clock:**  The rising edge of PCLK times all transfers on the APB.

**PRESET:** System bus equivalent Reset. The APB reset signal is active LOW.

**PADDR:** 32 bit address bus PSEL The slave device is selected and that a data transfer is required.

**PENABLE Enable:** This signal indicates the second and subsequent cycles of an APB transfer.

**PWRITE:** Access when HIGH.

**PWDATA:** 32 bits Write data PWRITE is HIGH.

**PREADY:** Ready To extend an APB transfer.

**PRDATA:** 32 bits Read data and PWRITE is LOW.

**PSLAVERR:** Slave error: This signal indicates a transfer failure.
















