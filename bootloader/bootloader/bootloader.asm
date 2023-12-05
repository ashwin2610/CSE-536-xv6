
bootloader/bootloader:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00001117          	auipc	sp,0x1
    80000004:	00010113          	mv	sp,sp
    80000008:	6505                	lui	a0,0x1
    8000000a:	912a                	add	sp,sp,a0
    8000000c:	122000ef          	jal	ra,8000012e <start>

0000000080000010 <spin>:
    80000010:	a001                	j	80000010 <spin>

0000000080000012 <r_mhartid>:
}

// which hart (core) is this?
static inline uint64
r_mhartid()
{
    80000012:	1101                	addi	sp,sp,-32 # 80000fe0 <ecode+0x92c>
    80000014:	ec22                	sd	s0,24(sp)
    80000016:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000018:	f14027f3          	csrr	a5,mhartid
    8000001c:	fef43423          	sd	a5,-24(s0)
  return x;
    80000020:	fe843783          	ld	a5,-24(s0)
}
    80000024:	853e                	mv	a0,a5
    80000026:	6462                	ld	s0,24(sp)
    80000028:	6105                	addi	sp,sp,32
    8000002a:	8082                	ret

000000008000002c <r_mstatus>:
#define MSTATUS_MPP_U (0L << 11)
#define MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64
r_mstatus()
{
    8000002c:	1101                	addi	sp,sp,-32
    8000002e:	ec22                	sd	s0,24(sp)
    80000030:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000032:	300027f3          	csrr	a5,mstatus
    80000036:	fef43423          	sd	a5,-24(s0)
  return x;
    8000003a:	fe843783          	ld	a5,-24(s0)
}
    8000003e:	853e                	mv	a0,a5
    80000040:	6462                	ld	s0,24(sp)
    80000042:	6105                	addi	sp,sp,32
    80000044:	8082                	ret

0000000080000046 <w_mstatus>:

static inline void 
w_mstatus(uint64 x)
{
    80000046:	1101                	addi	sp,sp,-32
    80000048:	ec22                	sd	s0,24(sp)
    8000004a:	1000                	addi	s0,sp,32
    8000004c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000050:	fe843783          	ld	a5,-24(s0)
    80000054:	30079073          	csrw	mstatus,a5
}
    80000058:	0001                	nop
    8000005a:	6462                	ld	s0,24(sp)
    8000005c:	6105                	addi	sp,sp,32
    8000005e:	8082                	ret

0000000080000060 <r_sie>:
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline uint64
r_sie()
{
    80000060:	1101                	addi	sp,sp,-32
    80000062:	ec22                	sd	s0,24(sp)
    80000064:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000066:	104027f3          	csrr	a5,sie
    8000006a:	fef43423          	sd	a5,-24(s0)
  return x;
    8000006e:	fe843783          	ld	a5,-24(s0)
}
    80000072:	853e                	mv	a0,a5
    80000074:	6462                	ld	s0,24(sp)
    80000076:	6105                	addi	sp,sp,32
    80000078:	8082                	ret

000000008000007a <w_sie>:

static inline void 
w_sie(uint64 x)
{
    8000007a:	1101                	addi	sp,sp,-32
    8000007c:	ec22                	sd	s0,24(sp)
    8000007e:	1000                	addi	s0,sp,32
    80000080:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    80000084:	fe843783          	ld	a5,-24(s0)
    80000088:	10479073          	csrw	sie,a5
}
    8000008c:	0001                	nop
    8000008e:	6462                	ld	s0,24(sp)
    80000090:	6105                	addi	sp,sp,32
    80000092:	8082                	ret

0000000080000094 <w_medeleg>:
  return x;
}

static inline void 
w_medeleg(uint64 x)
{
    80000094:	1101                	addi	sp,sp,-32
    80000096:	ec22                	sd	s0,24(sp)
    80000098:	1000                	addi	s0,sp,32
    8000009a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000009e:	fe843783          	ld	a5,-24(s0)
    800000a2:	30279073          	csrw	medeleg,a5
}
    800000a6:	0001                	nop
    800000a8:	6462                	ld	s0,24(sp)
    800000aa:	6105                	addi	sp,sp,32
    800000ac:	8082                	ret

00000000800000ae <w_mideleg>:
  return x;
}

static inline void 
w_mideleg(uint64 x)
{
    800000ae:	1101                	addi	sp,sp,-32
    800000b0:	ec22                	sd	s0,24(sp)
    800000b2:	1000                	addi	s0,sp,32
    800000b4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000b8:	fe843783          	ld	a5,-24(s0)
    800000bc:	30379073          	csrw	mideleg,a5
}
    800000c0:	0001                	nop
    800000c2:	6462                	ld	s0,24(sp)
    800000c4:	6105                	addi	sp,sp,32
    800000c6:	8082                	ret

00000000800000c8 <w_pmpcfg0>:
}

// Physical Memory Protection
static inline void
w_pmpcfg0(uint64 x)
{
    800000c8:	1101                	addi	sp,sp,-32
    800000ca:	ec22                	sd	s0,24(sp)
    800000cc:	1000                	addi	s0,sp,32
    800000ce:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000d2:	fe843783          	ld	a5,-24(s0)
    800000d6:	3a079073          	csrw	pmpcfg0,a5
}
    800000da:	0001                	nop
    800000dc:	6462                	ld	s0,24(sp)
    800000de:	6105                	addi	sp,sp,32
    800000e0:	8082                	ret

00000000800000e2 <w_pmpaddr0>:

static inline void
w_pmpaddr0(uint64 x)
{
    800000e2:	1101                	addi	sp,sp,-32
    800000e4:	ec22                	sd	s0,24(sp)
    800000e6:	1000                	addi	s0,sp,32
    800000e8:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ec:	fe843783          	ld	a5,-24(s0)
    800000f0:	3b079073          	csrw	pmpaddr0,a5
}
    800000f4:	0001                	nop
    800000f6:	6462                	ld	s0,24(sp)
    800000f8:	6105                	addi	sp,sp,32
    800000fa:	8082                	ret

00000000800000fc <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
    800000fc:	1101                	addi	sp,sp,-32
    800000fe:	ec22                	sd	s0,24(sp)
    80000100:	1000                	addi	s0,sp,32
    80000102:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80000106:	fe843783          	ld	a5,-24(s0)
    8000010a:	18079073          	csrw	satp,a5
}
    8000010e:	0001                	nop
    80000110:	6462                	ld	s0,24(sp)
    80000112:	6105                	addi	sp,sp,32
    80000114:	8082                	ret

0000000080000116 <w_tp>:
  return x;
}

static inline void 
w_tp(uint64 x)
{
    80000116:	1101                	addi	sp,sp,-32
    80000118:	ec22                	sd	s0,24(sp)
    8000011a:	1000                	addi	s0,sp,32
    8000011c:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    80000120:	fe843783          	ld	a5,-24(s0)
    80000124:	823e                	mv	tp,a5
}
    80000126:	0001                	nop
    80000128:	6462                	ld	s0,24(sp)
    8000012a:	6105                	addi	sp,sp,32
    8000012c:	8082                	ret

000000008000012e <start>:
extern void _entry(void);

// entry.S jumps here in machine mode on stack0.
void
start()
{
    8000012e:	7139                	addi	sp,sp,-64
    80000130:	fc06                	sd	ra,56(sp)
    80000132:	f822                	sd	s0,48(sp)
    80000134:	0080                	addi	s0,sp,64
  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	edc080e7          	jalr	-292(ra) # 80000012 <r_mhartid>
    8000013e:	87aa                	mv	a5,a0
    80000140:	fef42623          	sw	a5,-20(s0)
  w_tp(id);
    80000144:	fec42783          	lw	a5,-20(s0)
    80000148:	853e                	mv	a0,a5
    8000014a:	00000097          	auipc	ra,0x0
    8000014e:	fcc080e7          	jalr	-52(ra) # 80000116 <w_tp>

  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    80000152:	00000097          	auipc	ra,0x0
    80000156:	eda080e7          	jalr	-294(ra) # 8000002c <r_mstatus>
    8000015a:	fea43023          	sd	a0,-32(s0)
  x &= ~MSTATUS_MPP_MASK;
    8000015e:	fe043703          	ld	a4,-32(s0)
    80000162:	77f9                	lui	a5,0xffffe
    80000164:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <kernel_phdr+0xffffffff7fff5097>
    80000168:	8ff9                	and	a5,a5,a4
    8000016a:	fef43023          	sd	a5,-32(s0)
  x |= MSTATUS_MPP_S;
    8000016e:	fe043703          	ld	a4,-32(s0)
    80000172:	6785                	lui	a5,0x1
    80000174:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80000178:	8fd9                	or	a5,a5,a4
    8000017a:	fef43023          	sd	a5,-32(s0)
  w_mstatus(x);
    8000017e:	fe043503          	ld	a0,-32(s0)
    80000182:	00000097          	auipc	ra,0x0
    80000186:	ec4080e7          	jalr	-316(ra) # 80000046 <w_mstatus>

  // disable paging for now.
  w_satp(0);
    8000018a:	4501                	li	a0,0
    8000018c:	00000097          	auipc	ra,0x0
    80000190:	f70080e7          	jalr	-144(ra) # 800000fc <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    80000194:	67c1                	lui	a5,0x10
    80000196:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000019a:	00000097          	auipc	ra,0x0
    8000019e:	efa080e7          	jalr	-262(ra) # 80000094 <w_medeleg>
  w_mideleg(0xffff);
    800001a2:	67c1                	lui	a5,0x10
    800001a4:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    800001a8:	00000097          	auipc	ra,0x0
    800001ac:	f06080e7          	jalr	-250(ra) # 800000ae <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800001b0:	00000097          	auipc	ra,0x0
    800001b4:	eb0080e7          	jalr	-336(ra) # 80000060 <r_sie>
    800001b8:	87aa                	mv	a5,a0
    800001ba:	2227e793          	ori	a5,a5,546
    800001be:	853e                	mv	a0,a5
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	eba080e7          	jalr	-326(ra) # 8000007a <w_sie>

  //base address (80000000) plus 117 MB (7500000)
  w_pmpaddr0((0x80000000 + 0x7500000) >> 2); 
    800001c8:	21d40537          	lui	a0,0x21d40
    800001cc:	00000097          	auipc	ra,0x0
    800001d0:	f16080e7          	jalr	-234(ra) # 800000e2 <w_pmpaddr0>
  w_pmpcfg0(0xF);
    800001d4:	453d                	li	a0,15
    800001d6:	00000097          	auipc	ra,0x0
    800001da:	ef2080e7          	jalr	-270(ra) # 800000c8 <w_pmpcfg0>

  // CSE 536: Task 2.5
  // Load the kernel binary to its correct location
  uint64 kernel_entry_addr = 0;
    800001de:	fc043c23          	sd	zero,-40(s0)
  uint64 kernel_load_addr  = 0;
    800001e2:	fc043823          	sd	zero,-48(s0)
  uint64 kernel_size       = 0;
    800001e6:	fc043423          	sd	zero,-56(s0)

  // CSE 536: Task 2.5.1
  // Find the loading address of the kernel binary
  kernel_load_addr  = find_kernel_load_addr();
    800001ea:	00000097          	auipc	ra,0x0
    800001ee:	450080e7          	jalr	1104(ra) # 8000063a <find_kernel_load_addr>
    800001f2:	fca43823          	sd	a0,-48(s0)

  // CSE 536: Task 2.5.2
  // Find the kernel binary size and copy it to the load address
  kernel_size       = find_kernel_size();
    800001f6:	00000097          	auipc	ra,0x0
    800001fa:	49e080e7          	jalr	1182(ra) # 80000694 <find_kernel_size>
    800001fe:	fca43423          	sd	a0,-56(s0)

  // CSE 536: Task 2.5.3
  // Find the entry address and write it to mepc
  kernel_entry_addr = find_kernel_entry_addr();
    80000202:	00000097          	auipc	ra,0x0
    80000206:	4a2080e7          	jalr	1186(ra) # 800006a4 <find_kernel_entry_addr>
    8000020a:	fca43c23          	sd	a0,-40(s0)
  // CSE 536: Task 2.6
  // Provide system information to the kernel

  // CSE 536: Task 2.5.3
  // Jump to the OS kernel code
    8000020e:	0001                	nop
    80000210:	70e2                	ld	ra,56(sp)
    80000212:	7442                	ld	s0,48(sp)
    80000214:	6121                	addi	sp,sp,64
    80000216:	8082                	ret

0000000080000218 <kernel_copy>:

// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
kernel_copy(struct buf *b)
{
    80000218:	7179                	addi	sp,sp,-48
    8000021a:	f406                	sd	ra,40(sp)
    8000021c:	f022                	sd	s0,32(sp)
    8000021e:	1800                	addi	s0,sp,48
    80000220:	fca43c23          	sd	a0,-40(s0)
  /* Ramdisk is not even reading from the damn file.. */
  if(b->blockno >= FSSIZE)
    80000224:	fd843783          	ld	a5,-40(s0)
    80000228:	47dc                	lw	a5,12(a5)
    8000022a:	873e                	mv	a4,a5
    8000022c:	7cf00793          	li	a5,1999
    80000230:	00e7f663          	bgeu	a5,a4,8000023c <kernel_copy+0x24>
    spin();
    80000234:	00000097          	auipc	ra,0x0
    80000238:	ddc080e7          	jalr	-548(ra) # 80000010 <spin>

  uint64 diskaddr = b->blockno * BSIZE;
    8000023c:	fd843783          	ld	a5,-40(s0)
    80000240:	47dc                	lw	a5,12(a5)
    80000242:	00a7979b          	slliw	a5,a5,0xa
    80000246:	2781                	sext.w	a5,a5
    80000248:	1782                	slli	a5,a5,0x20
    8000024a:	9381                	srli	a5,a5,0x20
    8000024c:	fef43423          	sd	a5,-24(s0)
  char *addr = (char *)RAMDISK + diskaddr;
    80000250:	fe843703          	ld	a4,-24(s0)
    80000254:	02100793          	li	a5,33
    80000258:	07ea                	slli	a5,a5,0x1a
    8000025a:	97ba                	add	a5,a5,a4
    8000025c:	fef43023          	sd	a5,-32(s0)

  // read from the location
  memmove(b->data, addr, BSIZE);
    80000260:	fd843783          	ld	a5,-40(s0)
    80000264:	02878793          	addi	a5,a5,40
    80000268:	40000613          	li	a2,1024
    8000026c:	fe043583          	ld	a1,-32(s0)
    80000270:	853e                	mv	a0,a5
    80000272:	00000097          	auipc	ra,0x0
    80000276:	0f6080e7          	jalr	246(ra) # 80000368 <memmove>
}
    8000027a:	0001                	nop
    8000027c:	70a2                	ld	ra,40(sp)
    8000027e:	7402                	ld	s0,32(sp)
    80000280:	6145                	addi	sp,sp,48
    80000282:	8082                	ret

0000000080000284 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000284:	7179                	addi	sp,sp,-48
    80000286:	f422                	sd	s0,40(sp)
    80000288:	1800                	addi	s0,sp,48
    8000028a:	fca43c23          	sd	a0,-40(s0)
    8000028e:	87ae                	mv	a5,a1
    80000290:	8732                	mv	a4,a2
    80000292:	fcf42a23          	sw	a5,-44(s0)
    80000296:	87ba                	mv	a5,a4
    80000298:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    8000029c:	fd843783          	ld	a5,-40(s0)
    800002a0:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    800002a4:	fe042623          	sw	zero,-20(s0)
    800002a8:	a00d                	j	800002ca <memset+0x46>
    cdst[i] = c;
    800002aa:	fec42783          	lw	a5,-20(s0)
    800002ae:	fe043703          	ld	a4,-32(s0)
    800002b2:	97ba                	add	a5,a5,a4
    800002b4:	fd442703          	lw	a4,-44(s0)
    800002b8:	0ff77713          	zext.b	a4,a4
    800002bc:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    800002c0:	fec42783          	lw	a5,-20(s0)
    800002c4:	2785                	addiw	a5,a5,1
    800002c6:	fef42623          	sw	a5,-20(s0)
    800002ca:	fec42703          	lw	a4,-20(s0)
    800002ce:	fd042783          	lw	a5,-48(s0)
    800002d2:	2781                	sext.w	a5,a5
    800002d4:	fcf76be3          	bltu	a4,a5,800002aa <memset+0x26>
  }
  return dst;
    800002d8:	fd843783          	ld	a5,-40(s0)
}
    800002dc:	853e                	mv	a0,a5
    800002de:	7422                	ld	s0,40(sp)
    800002e0:	6145                	addi	sp,sp,48
    800002e2:	8082                	ret

00000000800002e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002e4:	7139                	addi	sp,sp,-64
    800002e6:	fc22                	sd	s0,56(sp)
    800002e8:	0080                	addi	s0,sp,64
    800002ea:	fca43c23          	sd	a0,-40(s0)
    800002ee:	fcb43823          	sd	a1,-48(s0)
    800002f2:	87b2                	mv	a5,a2
    800002f4:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    800002f8:	fd843783          	ld	a5,-40(s0)
    800002fc:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    80000300:	fd043783          	ld	a5,-48(s0)
    80000304:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    80000308:	a0a1                	j	80000350 <memcmp+0x6c>
    if(*s1 != *s2)
    8000030a:	fe843783          	ld	a5,-24(s0)
    8000030e:	0007c703          	lbu	a4,0(a5)
    80000312:	fe043783          	ld	a5,-32(s0)
    80000316:	0007c783          	lbu	a5,0(a5)
    8000031a:	02f70163          	beq	a4,a5,8000033c <memcmp+0x58>
      return *s1 - *s2;
    8000031e:	fe843783          	ld	a5,-24(s0)
    80000322:	0007c783          	lbu	a5,0(a5)
    80000326:	0007871b          	sext.w	a4,a5
    8000032a:	fe043783          	ld	a5,-32(s0)
    8000032e:	0007c783          	lbu	a5,0(a5)
    80000332:	2781                	sext.w	a5,a5
    80000334:	40f707bb          	subw	a5,a4,a5
    80000338:	2781                	sext.w	a5,a5
    8000033a:	a01d                	j	80000360 <memcmp+0x7c>
    s1++, s2++;
    8000033c:	fe843783          	ld	a5,-24(s0)
    80000340:	0785                	addi	a5,a5,1
    80000342:	fef43423          	sd	a5,-24(s0)
    80000346:	fe043783          	ld	a5,-32(s0)
    8000034a:	0785                	addi	a5,a5,1
    8000034c:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    80000350:	fcc42783          	lw	a5,-52(s0)
    80000354:	fff7871b          	addiw	a4,a5,-1
    80000358:	fce42623          	sw	a4,-52(s0)
    8000035c:	f7dd                	bnez	a5,8000030a <memcmp+0x26>
  }

  return 0;
    8000035e:	4781                	li	a5,0
}
    80000360:	853e                	mv	a0,a5
    80000362:	7462                	ld	s0,56(sp)
    80000364:	6121                	addi	sp,sp,64
    80000366:	8082                	ret

0000000080000368 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000368:	7139                	addi	sp,sp,-64
    8000036a:	fc22                	sd	s0,56(sp)
    8000036c:	0080                	addi	s0,sp,64
    8000036e:	fca43c23          	sd	a0,-40(s0)
    80000372:	fcb43823          	sd	a1,-48(s0)
    80000376:	87b2                	mv	a5,a2
    80000378:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  if(n == 0)
    8000037c:	fcc42783          	lw	a5,-52(s0)
    80000380:	2781                	sext.w	a5,a5
    80000382:	e781                	bnez	a5,8000038a <memmove+0x22>
    return dst;
    80000384:	fd843783          	ld	a5,-40(s0)
    80000388:	a855                	j	8000043c <memmove+0xd4>
  
  s = src;
    8000038a:	fd043783          	ld	a5,-48(s0)
    8000038e:	fef43423          	sd	a5,-24(s0)
  d = dst;
    80000392:	fd843783          	ld	a5,-40(s0)
    80000396:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    8000039a:	fe843703          	ld	a4,-24(s0)
    8000039e:	fe043783          	ld	a5,-32(s0)
    800003a2:	08f77463          	bgeu	a4,a5,8000042a <memmove+0xc2>
    800003a6:	fcc46783          	lwu	a5,-52(s0)
    800003aa:	fe843703          	ld	a4,-24(s0)
    800003ae:	97ba                	add	a5,a5,a4
    800003b0:	fe043703          	ld	a4,-32(s0)
    800003b4:	06f77b63          	bgeu	a4,a5,8000042a <memmove+0xc2>
    s += n;
    800003b8:	fcc46783          	lwu	a5,-52(s0)
    800003bc:	fe843703          	ld	a4,-24(s0)
    800003c0:	97ba                	add	a5,a5,a4
    800003c2:	fef43423          	sd	a5,-24(s0)
    d += n;
    800003c6:	fcc46783          	lwu	a5,-52(s0)
    800003ca:	fe043703          	ld	a4,-32(s0)
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    800003d4:	a01d                	j	800003fa <memmove+0x92>
      *--d = *--s;
    800003d6:	fe843783          	ld	a5,-24(s0)
    800003da:	17fd                	addi	a5,a5,-1
    800003dc:	fef43423          	sd	a5,-24(s0)
    800003e0:	fe043783          	ld	a5,-32(s0)
    800003e4:	17fd                	addi	a5,a5,-1
    800003e6:	fef43023          	sd	a5,-32(s0)
    800003ea:	fe843783          	ld	a5,-24(s0)
    800003ee:	0007c703          	lbu	a4,0(a5)
    800003f2:	fe043783          	ld	a5,-32(s0)
    800003f6:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    800003fa:	fcc42783          	lw	a5,-52(s0)
    800003fe:	fff7871b          	addiw	a4,a5,-1
    80000402:	fce42623          	sw	a4,-52(s0)
    80000406:	fbe1                	bnez	a5,800003d6 <memmove+0x6e>
  if(s < d && s + n > d){
    80000408:	a805                	j	80000438 <memmove+0xd0>
  } else
    while(n-- > 0)
      *d++ = *s++;
    8000040a:	fe843703          	ld	a4,-24(s0)
    8000040e:	00170793          	addi	a5,a4,1
    80000412:	fef43423          	sd	a5,-24(s0)
    80000416:	fe043783          	ld	a5,-32(s0)
    8000041a:	00178693          	addi	a3,a5,1
    8000041e:	fed43023          	sd	a3,-32(s0)
    80000422:	00074703          	lbu	a4,0(a4)
    80000426:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    8000042a:	fcc42783          	lw	a5,-52(s0)
    8000042e:	fff7871b          	addiw	a4,a5,-1
    80000432:	fce42623          	sw	a4,-52(s0)
    80000436:	fbf1                	bnez	a5,8000040a <memmove+0xa2>

  return dst;
    80000438:	fd843783          	ld	a5,-40(s0)
}
    8000043c:	853e                	mv	a0,a5
    8000043e:	7462                	ld	s0,56(sp)
    80000440:	6121                	addi	sp,sp,64
    80000442:	8082                	ret

0000000080000444 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000444:	7179                	addi	sp,sp,-48
    80000446:	f406                	sd	ra,40(sp)
    80000448:	f022                	sd	s0,32(sp)
    8000044a:	1800                	addi	s0,sp,48
    8000044c:	fea43423          	sd	a0,-24(s0)
    80000450:	feb43023          	sd	a1,-32(s0)
    80000454:	87b2                	mv	a5,a2
    80000456:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    8000045a:	fdc42783          	lw	a5,-36(s0)
    8000045e:	863e                	mv	a2,a5
    80000460:	fe043583          	ld	a1,-32(s0)
    80000464:	fe843503          	ld	a0,-24(s0)
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	f00080e7          	jalr	-256(ra) # 80000368 <memmove>
    80000470:	87aa                	mv	a5,a0
}
    80000472:	853e                	mv	a0,a5
    80000474:	70a2                	ld	ra,40(sp)
    80000476:	7402                	ld	s0,32(sp)
    80000478:	6145                	addi	sp,sp,48
    8000047a:	8082                	ret

000000008000047c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000047c:	7179                	addi	sp,sp,-48
    8000047e:	f422                	sd	s0,40(sp)
    80000480:	1800                	addi	s0,sp,48
    80000482:	fea43423          	sd	a0,-24(s0)
    80000486:	feb43023          	sd	a1,-32(s0)
    8000048a:	87b2                	mv	a5,a2
    8000048c:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    80000490:	a005                	j	800004b0 <strncmp+0x34>
    n--, p++, q++;
    80000492:	fdc42783          	lw	a5,-36(s0)
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	fcf42e23          	sw	a5,-36(s0)
    8000049c:	fe843783          	ld	a5,-24(s0)
    800004a0:	0785                	addi	a5,a5,1
    800004a2:	fef43423          	sd	a5,-24(s0)
    800004a6:	fe043783          	ld	a5,-32(s0)
    800004aa:	0785                	addi	a5,a5,1
    800004ac:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    800004b0:	fdc42783          	lw	a5,-36(s0)
    800004b4:	2781                	sext.w	a5,a5
    800004b6:	c385                	beqz	a5,800004d6 <strncmp+0x5a>
    800004b8:	fe843783          	ld	a5,-24(s0)
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	cb99                	beqz	a5,800004d6 <strncmp+0x5a>
    800004c2:	fe843783          	ld	a5,-24(s0)
    800004c6:	0007c703          	lbu	a4,0(a5)
    800004ca:	fe043783          	ld	a5,-32(s0)
    800004ce:	0007c783          	lbu	a5,0(a5)
    800004d2:	fcf700e3          	beq	a4,a5,80000492 <strncmp+0x16>
  if(n == 0)
    800004d6:	fdc42783          	lw	a5,-36(s0)
    800004da:	2781                	sext.w	a5,a5
    800004dc:	e399                	bnez	a5,800004e2 <strncmp+0x66>
    return 0;
    800004de:	4781                	li	a5,0
    800004e0:	a839                	j	800004fe <strncmp+0x82>
  return (uchar)*p - (uchar)*q;
    800004e2:	fe843783          	ld	a5,-24(s0)
    800004e6:	0007c783          	lbu	a5,0(a5)
    800004ea:	0007871b          	sext.w	a4,a5
    800004ee:	fe043783          	ld	a5,-32(s0)
    800004f2:	0007c783          	lbu	a5,0(a5)
    800004f6:	2781                	sext.w	a5,a5
    800004f8:	40f707bb          	subw	a5,a4,a5
    800004fc:	2781                	sext.w	a5,a5
}
    800004fe:	853e                	mv	a0,a5
    80000500:	7422                	ld	s0,40(sp)
    80000502:	6145                	addi	sp,sp,48
    80000504:	8082                	ret

0000000080000506 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000506:	7139                	addi	sp,sp,-64
    80000508:	fc22                	sd	s0,56(sp)
    8000050a:	0080                	addi	s0,sp,64
    8000050c:	fca43c23          	sd	a0,-40(s0)
    80000510:	fcb43823          	sd	a1,-48(s0)
    80000514:	87b2                	mv	a5,a2
    80000516:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000051a:	fd843783          	ld	a5,-40(s0)
    8000051e:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000522:	0001                	nop
    80000524:	fcc42783          	lw	a5,-52(s0)
    80000528:	fff7871b          	addiw	a4,a5,-1
    8000052c:	fce42623          	sw	a4,-52(s0)
    80000530:	02f05e63          	blez	a5,8000056c <strncpy+0x66>
    80000534:	fd043703          	ld	a4,-48(s0)
    80000538:	00170793          	addi	a5,a4,1
    8000053c:	fcf43823          	sd	a5,-48(s0)
    80000540:	fd843783          	ld	a5,-40(s0)
    80000544:	00178693          	addi	a3,a5,1
    80000548:	fcd43c23          	sd	a3,-40(s0)
    8000054c:	00074703          	lbu	a4,0(a4)
    80000550:	00e78023          	sb	a4,0(a5)
    80000554:	0007c783          	lbu	a5,0(a5)
    80000558:	f7f1                	bnez	a5,80000524 <strncpy+0x1e>
    ;
  while(n-- > 0)
    8000055a:	a809                	j	8000056c <strncpy+0x66>
    *s++ = 0;
    8000055c:	fd843783          	ld	a5,-40(s0)
    80000560:	00178713          	addi	a4,a5,1
    80000564:	fce43c23          	sd	a4,-40(s0)
    80000568:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    8000056c:	fcc42783          	lw	a5,-52(s0)
    80000570:	fff7871b          	addiw	a4,a5,-1
    80000574:	fce42623          	sw	a4,-52(s0)
    80000578:	fef042e3          	bgtz	a5,8000055c <strncpy+0x56>
  return os;
    8000057c:	fe843783          	ld	a5,-24(s0)
}
    80000580:	853e                	mv	a0,a5
    80000582:	7462                	ld	s0,56(sp)
    80000584:	6121                	addi	sp,sp,64
    80000586:	8082                	ret

0000000080000588 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000588:	7139                	addi	sp,sp,-64
    8000058a:	fc22                	sd	s0,56(sp)
    8000058c:	0080                	addi	s0,sp,64
    8000058e:	fca43c23          	sd	a0,-40(s0)
    80000592:	fcb43823          	sd	a1,-48(s0)
    80000596:	87b2                	mv	a5,a2
    80000598:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000059c:	fd843783          	ld	a5,-40(s0)
    800005a0:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    800005a4:	fcc42783          	lw	a5,-52(s0)
    800005a8:	2781                	sext.w	a5,a5
    800005aa:	00f04563          	bgtz	a5,800005b4 <safestrcpy+0x2c>
    return os;
    800005ae:	fe843783          	ld	a5,-24(s0)
    800005b2:	a0a9                	j	800005fc <safestrcpy+0x74>
  while(--n > 0 && (*s++ = *t++) != 0)
    800005b4:	0001                	nop
    800005b6:	fcc42783          	lw	a5,-52(s0)
    800005ba:	37fd                	addiw	a5,a5,-1
    800005bc:	fcf42623          	sw	a5,-52(s0)
    800005c0:	fcc42783          	lw	a5,-52(s0)
    800005c4:	2781                	sext.w	a5,a5
    800005c6:	02f05563          	blez	a5,800005f0 <safestrcpy+0x68>
    800005ca:	fd043703          	ld	a4,-48(s0)
    800005ce:	00170793          	addi	a5,a4,1
    800005d2:	fcf43823          	sd	a5,-48(s0)
    800005d6:	fd843783          	ld	a5,-40(s0)
    800005da:	00178693          	addi	a3,a5,1
    800005de:	fcd43c23          	sd	a3,-40(s0)
    800005e2:	00074703          	lbu	a4,0(a4)
    800005e6:	00e78023          	sb	a4,0(a5)
    800005ea:	0007c783          	lbu	a5,0(a5)
    800005ee:	f7e1                	bnez	a5,800005b6 <safestrcpy+0x2e>
    ;
  *s = 0;
    800005f0:	fd843783          	ld	a5,-40(s0)
    800005f4:	00078023          	sb	zero,0(a5)
  return os;
    800005f8:	fe843783          	ld	a5,-24(s0)
}
    800005fc:	853e                	mv	a0,a5
    800005fe:	7462                	ld	s0,56(sp)
    80000600:	6121                	addi	sp,sp,64
    80000602:	8082                	ret

0000000080000604 <strlen>:

int
strlen(const char *s)
{
    80000604:	7179                	addi	sp,sp,-48
    80000606:	f422                	sd	s0,40(sp)
    80000608:	1800                	addi	s0,sp,48
    8000060a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    8000060e:	fe042623          	sw	zero,-20(s0)
    80000612:	a031                	j	8000061e <strlen+0x1a>
    80000614:	fec42783          	lw	a5,-20(s0)
    80000618:	2785                	addiw	a5,a5,1
    8000061a:	fef42623          	sw	a5,-20(s0)
    8000061e:	fec42783          	lw	a5,-20(s0)
    80000622:	fd843703          	ld	a4,-40(s0)
    80000626:	97ba                	add	a5,a5,a4
    80000628:	0007c783          	lbu	a5,0(a5)
    8000062c:	f7e5                	bnez	a5,80000614 <strlen+0x10>
    ;
  return n;
    8000062e:	fec42783          	lw	a5,-20(s0)
}
    80000632:	853e                	mv	a0,a5
    80000634:	7422                	ld	s0,40(sp)
    80000636:	6145                	addi	sp,sp,48
    80000638:	8082                	ret

000000008000063a <find_kernel_load_addr>:
#include <stdbool.h>

struct elfhdr* kernel_elfhdr;
struct proghdr* kernel_phdr;

uint64 find_kernel_load_addr(void) {
    8000063a:	1141                	addi	sp,sp,-16
    8000063c:	e422                	sd	s0,8(sp)
    8000063e:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.1
    kernel_elfhdr = (struct elfhdr*) RAMDISK;
    80000640:	00009797          	auipc	a5,0x9
    80000644:	12078793          	addi	a5,a5,288 # 80009760 <kernel_elfhdr>
    80000648:	02100713          	li	a4,33
    8000064c:	076a                	slli	a4,a4,0x1a
    8000064e:	e398                	sd	a4,0(a5)

    kernel_phdr = (struct proghdr*) (RAMDISK  + kernel_elfhdr->phoff + kernel_elfhdr->phentsize);
    80000650:	00009797          	auipc	a5,0x9
    80000654:	11078793          	addi	a5,a5,272 # 80009760 <kernel_elfhdr>
    80000658:	639c                	ld	a5,0(a5)
    8000065a:	739c                	ld	a5,32(a5)
    8000065c:	00009717          	auipc	a4,0x9
    80000660:	10470713          	addi	a4,a4,260 # 80009760 <kernel_elfhdr>
    80000664:	6318                	ld	a4,0(a4)
    80000666:	03675703          	lhu	a4,54(a4)
    8000066a:	973e                	add	a4,a4,a5
    8000066c:	02100793          	li	a5,33
    80000670:	07ea                	slli	a5,a5,0x1a
    80000672:	97ba                	add	a5,a5,a4
    80000674:	873e                	mv	a4,a5
    80000676:	00009797          	auipc	a5,0x9
    8000067a:	0f278793          	addi	a5,a5,242 # 80009768 <kernel_phdr>
    8000067e:	e398                	sd	a4,0(a5)

    return kernel_phdr->vaddr;
    80000680:	00009797          	auipc	a5,0x9
    80000684:	0e878793          	addi	a5,a5,232 # 80009768 <kernel_phdr>
    80000688:	639c                	ld	a5,0(a5)
    8000068a:	6b9c                	ld	a5,16(a5)
}
    8000068c:	853e                	mv	a0,a5
    8000068e:	6422                	ld	s0,8(sp)
    80000690:	0141                	addi	sp,sp,16
    80000692:	8082                	ret

0000000080000694 <find_kernel_size>:

uint64 find_kernel_size(void) {
    80000694:	1141                	addi	sp,sp,-16
    80000696:	e422                	sd	s0,8(sp)
    80000698:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.2
    return 0;
    8000069a:	4781                	li	a5,0
}
    8000069c:	853e                	mv	a0,a5
    8000069e:	6422                	ld	s0,8(sp)
    800006a0:	0141                	addi	sp,sp,16
    800006a2:	8082                	ret

00000000800006a4 <find_kernel_entry_addr>:

uint64 find_kernel_entry_addr(void) {
    800006a4:	1141                	addi	sp,sp,-16
    800006a6:	e422                	sd	s0,8(sp)
    800006a8:	0800                	addi	s0,sp,16
    // CSE 536: task 2.5.3
    return 0;
    800006aa:	4781                	li	a5,0
    800006ac:	853e                	mv	a0,a5
    800006ae:	6422                	ld	s0,8(sp)
    800006b0:	0141                	addi	sp,sp,16
    800006b2:	8082                	ret
