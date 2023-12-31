
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 6b 11 80       	mov    $0x80116bf0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 86 10 80       	push   $0x80108620
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 55 00 00       	call   80105640 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 86 10 80       	push   $0x80108627
80100097:	50                   	push   %eax
80100098:	e8 73 54 00 00       	call   80105510 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 27 57 00 00       	call   80105810 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 49 56 00 00       	call   801057b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 53 00 00       	call   80105550 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 86 10 80       	push   $0x8010862e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 54 00 00       	call   801055f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 86 10 80       	push   $0x8010863f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 53 00 00       	call   801055f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 53 00 00       	call   801055b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 55 00 00       	call   80105810 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 55 00 00       	jmp    801057b0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 86 10 80       	push   $0x80108646
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 55 00 00       	call   80105810 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ce 49 00 00       	call   80104ca0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 3f 00 00       	call   801042b0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 54 00 00       	call   801057b0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 5f 54 00 00       	call   801057b0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 86 10 80       	push   $0x8010864d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 7f 8f 10 80 	movl   $0x80108f7f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 52 00 00       	call   80105660 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 86 10 80       	push   $0x80108661
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 6d 00 00       	call   80107130 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 6c 00 00       	call   80107130 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 6c 00 00       	call   80107130 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 6c 00 00       	call   80107130 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 1a 54 00 00       	call   80105970 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 53 00 00       	call   801058d0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 86 10 80       	push   $0x80108665
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 60 52 00 00       	call   80105810 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 c7 51 00 00       	call   801057b0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 90 86 10 80 	movzbl -0x7fef7970(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 23 50 00 00       	call   80105810 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 86 10 80       	mov    $0x80108678,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 50 4f 00 00       	call   801057b0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 86 10 80       	push   $0x8010867f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 78 4f 00 00       	call   80105810 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 db 4d 00 00       	call   801057b0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 4d 44 00 00       	jmp    80104e60 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 17 43 00 00       	call   80104d60 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 86 10 80       	push   $0x80108688
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 cb 4b 00 00       	call   80105640 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ef 37 00 00       	call   801042b0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 87 77 00 00       	call   801082c0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 38 75 00 00       	call   801080e0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 12 74 00 00       	call   80107ff0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 20 76 00 00       	call   80108240 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 79 74 00 00       	call   801080e0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 d8 76 00 00       	call   80108360 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 f8 4d 00 00       	call   80105ad0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 e4 4d 00 00       	call   80105ad0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 33 78 00 00       	call   80108530 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 75 00 00       	call   80108240 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 c8 77 00 00       	call   80108530 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ea 4c 00 00       	call   80105a90 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 8e 70 00 00       	call   80107e60 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 74 00 00       	call   80108240 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 86 10 80       	push   $0x801086a1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ad 86 10 80       	push   $0x801086ad
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 1b 48 00 00       	call   80105640 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 ca 49 00 00       	call   80105810 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 3a 49 00 00       	call   801057b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 21 49 00 00       	call   801057b0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 5c 49 00 00       	call   80105810 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 df 48 00 00       	call   801057b0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 86 10 80       	push   $0x801086b4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 0a 49 00 00       	call   80105810 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 6f 48 00 00       	call   801057b0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 3d 48 00 00       	jmp    801057b0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 bc 86 10 80       	push   $0x801086bc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 c6 86 10 80       	push   $0x801086c6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 cf 86 10 80       	push   $0x801086cf
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 d5 86 10 80       	push   $0x801086d5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 86 10 80       	push   $0x801086df
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 86 10 80       	push   $0x801086f2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 a6 45 00 00       	call   801058d0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 a1 44 00 00       	call   80105810 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 d4 43 00 00       	call   801057b0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 a6 43 00 00       	call   801057b0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 08 87 10 80       	push   $0x80108708
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 18 87 10 80       	push   $0x80108718
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 2a 44 00 00       	call   80105970 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 87 10 80       	push   $0x8010872b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 c5 40 00 00       	call   80105640 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 87 10 80       	push   $0x80108732
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 7c 3f 00 00       	call   80105510 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 af 43 00 00       	call   80105970 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 98 87 10 80       	push   $0x80108798
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 3d 42 00 00       	call   801058d0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 38 87 10 80       	push   $0x80108738
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 3a 42 00 00       	call   80105970 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 ac 40 00 00       	call   80105810 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 3c 40 00 00       	call   801057b0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 a9 3d 00 00       	call   80105550 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 53 41 00 00       	call   80105970 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 50 87 10 80       	push   $0x80108750
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 87 10 80       	push   $0x8010874a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 78 3d 00 00       	call   801055f0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 1c 3d 00 00       	jmp    801055b0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 87 10 80       	push   $0x8010875f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 8b 3c 00 00       	call   80105550 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 d1 3c 00 00       	call   801055b0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 25 3f 00 00       	call   80105810 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 ab 3e 00 00       	jmp    801057b0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 fb 3e 00 00       	call   80105810 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 8c 3e 00 00       	call   801057b0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 c8 3b 00 00       	call   801055f0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 71 3b 00 00       	call   801055b0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 5f 87 10 80       	push   $0x8010875f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 34 3e 00 00       	call   80105970 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 38 3d 00 00       	call   80105970 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 0d 3d 00 00       	call   801059e0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 ae 3c 00 00       	call   801059e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 79 87 10 80       	push   $0x80108779
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 87 10 80       	push   $0x80108767
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 01 25 00 00       	call   801042b0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 51 3a 00 00       	call   80105810 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 e1 39 00 00       	call   801057b0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 44 3b 00 00       	call   80105970 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 5f 37 00 00       	call   801055f0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 fd 36 00 00       	call   801055b0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 90 3a 00 00       	call   80105970 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 c0 36 00 00       	call   801055f0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 61 36 00 00       	call   801055b0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 7e 36 00 00       	call   801055f0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 5b 36 00 00       	call   801055f0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 04 36 00 00       	call   801055b0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 5f 87 10 80       	push   $0x8010875f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ee 39 00 00       	call   80105a30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 88 87 10 80       	push   $0x80108788
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 aa 8d 10 80       	push   $0x80108daa
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 f4 87 10 80       	push   $0x801087f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 87 10 80       	push   $0x801087eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 88 10 80       	push   $0x80108806
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 6b 34 00 00       	call   80105640 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 bd 35 00 00       	call   80105810 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 ae 2a 00 00       	call   80104d60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 e0 34 00 00       	call   801057b0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 fd 32 00 00       	call   801055f0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 e3 34 00 00       	call   80105810 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 32 29 00 00       	call   80104ca0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 25 34 00 00       	jmp    801057b0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 35 88 10 80       	push   $0x80108835
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 88 10 80       	push   $0x80108820
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 88 10 80       	push   $0x8010880a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 54 88 10 80       	push   $0x80108854
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb f0 6b 11 80    	cmp    $0x80116bf0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 d9 33 00 00       	call   801058d0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 e3 32 00 00       	call   80105810 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 68 32 00 00       	jmp    801057b0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 86 88 10 80       	push   $0x80108886
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 8c 88 10 80       	push   $0x8010888c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 16 30 00 00       	call   80105640 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 58 31 00 00       	call   80105810 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 ca 30 00 00       	call   801057b0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 c0 89 10 80 	movzbl -0x7fef7640(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 c0 88 10 80 	movzbl -0x7fef7740(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 a0 88 10 80 	mov    -0x7fef7760(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 c0 89 10 80 	movzbl -0x7fef7640(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 24 2e 00 00       	call   80105920 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 47 2d 00 00       	call   80105970 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 c0 8a 10 80       	push   $0x80108ac0
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 67 29 00 00       	call   80105640 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 a0 2a 00 00       	call   80105810 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 16 1f 00 00       	call   80104ca0 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 ef 29 00 00       	call   801057b0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 2d 2a 00 00       	call   80105810 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 8f 29 00 00       	call   801057b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 d5 29 00 00       	call   80105810 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 0f 1f 00 00       	call   80104d60 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 53 29 00 00       	call   801057b0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 b7 2a 00 00       	call   80105970 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 53 1e 00 00       	call   80104d60 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 97 28 00 00       	call   801057b0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 c4 8a 10 80       	push   $0x80108ac4
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 95 28 00 00       	call   80105810 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 f6 27 00 00       	jmp    801057b0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 d3 8a 10 80       	push   $0x80108ad3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 e9 8a 10 80       	push   $0x80108ae9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 84 12 00 00       	call   80104290 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 7d 12 00 00       	call   80104290 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 04 8b 10 80       	push   $0x80108b04
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 19 3d 00 00       	call   80106d40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 04 12 00 00       	call   80104230 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 21 16 00 00       	call   80104660 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 05 4e 00 00       	call   80107e50 <switchkvm>
  seginit();
8010304b:	e8 70 4d 00 00       	call   80107dc0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 f0 6b 11 80       	push   $0x80116bf0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 ba 52 00 00       	call   80108340 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 2b 4d 00 00       	call   80107dc0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 a7 3f 00 00       	call   80107050 <uartinit>
  pinit();         // process table
801030a9:	e8 42 11 00 00       	call   801041f0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 0d 3c 00 00       	call   80106cc0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 97 28 00 00       	call   80105970 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 12 11 00 00       	call   80104230 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 59 11 00 00       	call   801042e0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 18 8b 10 80       	push   $0x80108b18
801031c3:	56                   	push   %esi
801031c4:	e8 57 27 00 00       	call   80105920 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 1d 8b 10 80       	push   $0x80108b1d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 9c 26 00 00       	call   80105920 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 22 8b 10 80       	push   $0x80108b22
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 18 8b 10 80       	push   $0x80108b18
801033c7:	53                   	push   %ebx
801033c8:	e8 53 25 00 00       	call   80105920 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 3c 8b 10 80       	push   $0x80108b3c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 5b 8b 10 80       	push   $0x80108b5b
801034a8:	50                   	push   %eax
801034a9:	e8 92 21 00 00       	call   80105640 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 cc 22 00 00       	call   80105810 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 fc 17 00 00       	call   80104d60 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 27 22 00 00       	jmp    801057b0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 17 22 00 00       	call   801057b0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 97 17 00 00       	call   80104d60 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 2e 22 00 00       	call   80105810 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 83 0c 00 00       	call   801042b0 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 23 17 00 00       	call   80104d60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 5a 16 00 00       	call   80104ca0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 3f 21 00 00       	call   801057b0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 a1 16 00 00       	call   80104d60 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 e9 20 00 00       	call   801057b0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 25 21 00 00       	call   80105810 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 ab 0b 00 00       	call   801042b0 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 86 15 00 00       	call   80104ca0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 e5 15 00 00       	call   80104d60 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 2d 20 00 00       	call   801057b0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 12 20 00 00       	call   801057b0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 74 30 11 80       	mov    $0x80113074,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 40 30 11 80       	push   $0x80113040
801037c1:	e8 4a 20 00 00       	call   80105810 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037d6:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
801037dc:	0f 84 9e 00 00 00    	je     80103880 <allocproc+0xd0>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->numSwitches = 0;
  p->parent = &defaultParent;
  p->burst_time = 0;
  p->run_time = 0;
  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->numSwitches = 0;
801037f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801037ff:	00 00 00 
  p->pid = nextpid++;
80103802:	89 43 10             	mov    %eax,0x10(%ebx)
80103805:	8d 50 01             	lea    0x1(%eax),%edx
  p->parent = &defaultParent;
80103808:	c7 43 14 20 2d 11 80 	movl   $0x80112d20,0x14(%ebx)
  p->burst_time = 0;
8010380f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103816:	00 00 00 
  p->run_time = 0;
80103819:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103820:	00 00 00 
  release(&ptable.lock);
80103823:	68 40 30 11 80       	push   $0x80113040
  p->pid = nextpid++;
80103828:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010382e:	e8 7d 1f 00 00       	call   801057b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103833:	e8 48 ee ff ff       	call   80102680 <kalloc>
80103838:	83 c4 10             	add    $0x10,%esp
8010383b:	89 43 08             	mov    %eax,0x8(%ebx)
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 57                	je     80103899 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103842:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103848:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010384b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103850:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103853:	c7 40 14 ad 6c 10 80 	movl   $0x80106cad,0x14(%eax)
  p->context = (struct context*)sp;
8010385a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010385d:	6a 14                	push   $0x14
8010385f:	6a 00                	push   $0x0
80103861:	50                   	push   %eax
80103862:	e8 69 20 00 00       	call   801058d0 <memset>
  p->context->eip = (uint)forkret;
80103867:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010386d:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103874:	89 d8                	mov    %ebx,%eax
80103876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103879:	c9                   	leave  
8010387a:	c3                   	ret    
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 40 30 11 80       	push   $0x80113040
8010388a:	e8 21 1f 00 00       	call   801057b0 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 40 30 11 80       	push   $0x80113040
801038bb:	e8 f0 1e 00 00       	call   801057b0 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 7c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 d0 f3 ff ff       	call   80102cc0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <insertIntoPQ.part.0>:
void insertIntoPQ(struct proc *p){
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	89 c6                	mov    %eax,%esi
80103907:	53                   	push   %ebx
80103908:	83 ec 18             	sub    $0x18,%esp
	acquire(&priorityQ.lock);
8010390b:	68 04 2f 11 80       	push   $0x80112f04
80103910:	e8 fb 1e 00 00       	call   80105810 <acquire>
	priorityQ.sze++;
80103915:	a1 00 2f 11 80       	mov    0x80112f00,%eax
	while(!(curr<=1) && ((priorityQ.proc[curr]->burst_time)<(priorityQ.proc[curr/2]->burst_time))){
8010391a:	83 c4 10             	add    $0x10,%esp
	priorityQ.sze++;
8010391d:	8d 50 01             	lea    0x1(%eax),%edx
	priorityQ.proc[priorityQ.sze]=p;
80103920:	89 34 85 3c 2f 11 80 	mov    %esi,-0x7feed0c4(,%eax,4)
	priorityQ.sze++;
80103927:	89 15 00 2f 11 80    	mov    %edx,0x80112f00
	while(!(curr<=1) && ((priorityQ.proc[curr]->burst_time)<(priorityQ.proc[curr/2]->burst_time))){
8010392d:	83 fa 01             	cmp    $0x1,%edx
80103930:	7f 19                	jg     8010394b <insertIntoPQ.part.0+0x4b>
80103932:	eb 33                	jmp    80103967 <insertIntoPQ.part.0+0x67>
80103934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		priorityQ.proc[curr]=priorityQ.proc[curr/2];
80103938:	89 0c 85 38 2f 11 80 	mov    %ecx,-0x7feed0c8(,%eax,4)
		priorityQ.proc[curr/2]=temp;
8010393f:	89 34 9d 08 2f 11 80 	mov    %esi,-0x7feed0f8(,%ebx,4)
	while(!(curr<=1) && ((priorityQ.proc[curr]->burst_time)<(priorityQ.proc[curr/2]->burst_time))){
80103946:	83 fa 01             	cmp    $0x1,%edx
80103949:	74 1c                	je     80103967 <insertIntoPQ.part.0+0x67>
8010394b:	89 d0                	mov    %edx,%eax
8010394d:	d1 fa                	sar    %edx
8010394f:	8d 5a 0c             	lea    0xc(%edx),%ebx
80103952:	8b 0c 9d 08 2f 11 80 	mov    -0x7feed0f8(,%ebx,4),%ecx
80103959:	8b b9 84 00 00 00    	mov    0x84(%ecx),%edi
8010395f:	39 be 84 00 00 00    	cmp    %edi,0x84(%esi)
80103965:	7c d1                	jl     80103938 <insertIntoPQ.part.0+0x38>
	release(&priorityQ.lock);
80103967:	83 ec 0c             	sub    $0xc,%esp
8010396a:	68 04 2f 11 80       	push   $0x80112f04
8010396f:	e8 3c 1e 00 00       	call   801057b0 <release>
}
80103974:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103977:	5b                   	pop    %ebx
80103978:	5e                   	pop    %esi
80103979:	5f                   	pop    %edi
8010397a:	5d                   	pop    %ebp
8010397b:	c3                   	ret    
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <insertIntoPQ2.part.0>:
void insertIntoPQ2(struct proc *p){
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	89 c6                	mov    %eax,%esi
80103987:	53                   	push   %ebx
80103988:	83 ec 18             	sub    $0x18,%esp
	acquire(&priorityQ2.lock);
8010398b:	68 c4 2d 11 80       	push   $0x80112dc4
80103990:	e8 7b 1e 00 00       	call   80105810 <acquire>
	priorityQ2.sze++;
80103995:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
	while(curr>1 && ((priorityQ2.proc[curr]->burst_time)<(priorityQ2.proc[curr/2]->burst_time))){
8010399a:	83 c4 10             	add    $0x10,%esp
	priorityQ2.sze++;
8010399d:	8d 50 01             	lea    0x1(%eax),%edx
	priorityQ2.proc[priorityQ2.sze]=p;
801039a0:	89 34 85 fc 2d 11 80 	mov    %esi,-0x7feed204(,%eax,4)
	priorityQ2.sze++;
801039a7:	89 15 c0 2d 11 80    	mov    %edx,0x80112dc0
	while(curr>1 && ((priorityQ2.proc[curr]->burst_time)<(priorityQ2.proc[curr/2]->burst_time))){
801039ad:	83 fa 01             	cmp    $0x1,%edx
801039b0:	7f 19                	jg     801039cb <insertIntoPQ2.part.0+0x4b>
801039b2:	eb 33                	jmp    801039e7 <insertIntoPQ2.part.0+0x67>
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		priorityQ2.proc[curr]=priorityQ2.proc[curr/2];
801039b8:	89 0c 85 f8 2d 11 80 	mov    %ecx,-0x7feed208(,%eax,4)
		priorityQ2.proc[curr/2]=temp;
801039bf:	89 34 9d c8 2d 11 80 	mov    %esi,-0x7feed238(,%ebx,4)
	while(curr>1 && ((priorityQ2.proc[curr]->burst_time)<(priorityQ2.proc[curr/2]->burst_time))){
801039c6:	83 fa 01             	cmp    $0x1,%edx
801039c9:	74 1c                	je     801039e7 <insertIntoPQ2.part.0+0x67>
801039cb:	89 d0                	mov    %edx,%eax
801039cd:	d1 fa                	sar    %edx
801039cf:	8d 5a 0c             	lea    0xc(%edx),%ebx
801039d2:	8b 0c 9d c8 2d 11 80 	mov    -0x7feed238(,%ebx,4),%ecx
801039d9:	8b b9 84 00 00 00    	mov    0x84(%ecx),%edi
801039df:	39 be 84 00 00 00    	cmp    %edi,0x84(%esi)
801039e5:	7c d1                	jl     801039b8 <insertIntoPQ2.part.0+0x38>
	release(&priorityQ2.lock);
801039e7:	83 ec 0c             	sub    $0xc,%esp
801039ea:	68 c4 2d 11 80       	push   $0x80112dc4
801039ef:	e8 bc 1d 00 00       	call   801057b0 <release>
}
801039f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f7:	5b                   	pop    %ebx
801039f8:	5e                   	pop    %esi
801039f9:	5f                   	pop    %edi
801039fa:	5d                   	pop    %ebp
801039fb:	c3                   	ret    
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a00 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	89 c6                	mov    %eax,%esi
80103a06:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a07:	bb 74 30 11 80       	mov    $0x80113074,%ebx
80103a0c:	eb 10                	jmp    80103a1e <wakeup1+0x1e>
80103a0e:	66 90                	xchg   %ax,%ax
80103a10:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103a16:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80103a1c:	74 50                	je     80103a6e <wakeup1+0x6e>
    if(p->state == SLEEPING && p->chan == chan){
80103a1e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a22:	75 ec                	jne    80103a10 <wakeup1+0x10>
80103a24:	39 73 20             	cmp    %esi,0x20(%ebx)
80103a27:	75 e7                	jne    80103a10 <wakeup1+0x10>
	acquire(&priorityQ.lock);
80103a29:	83 ec 0c             	sub    $0xc,%esp
    	short check = (p->state !=RUNNABLE);

      p->state = RUNNABLE;
80103a2c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	acquire(&priorityQ.lock);
80103a33:	68 04 2f 11 80       	push   $0x80112f04
80103a38:	e8 d3 1d 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80103a3d:	83 c4 10             	add    $0x10,%esp
80103a40:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80103a47:	74 2f                	je     80103a78 <wakeup1+0x78>
		release(&priorityQ.lock);
80103a49:	83 ec 0c             	sub    $0xc,%esp
80103a4c:	68 04 2f 11 80       	push   $0x80112f04
80103a51:	e8 5a 1d 00 00       	call   801057b0 <release>
		return 0;
80103a56:	89 d8                	mov    %ebx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a58:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103a5e:	e8 9d fe ff ff       	call   80103900 <insertIntoPQ.part.0>
80103a63:	83 c4 10             	add    $0x10,%esp
80103a66:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80103a6c:	75 b0                	jne    80103a1e <wakeup1+0x1e>
      if(check)
      	insertIntoPQ(p);
    }
}
80103a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret    
80103a75:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
80103a78:	83 ec 0c             	sub    $0xc,%esp
80103a7b:	68 04 2f 11 80       	push   $0x80112f04
80103a80:	e8 2b 1d 00 00       	call   801057b0 <release>
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	eb 86                	jmp    80103a10 <wakeup1+0x10>
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <isEmpty>:
int isEmpty(){
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 14             	sub    $0x14,%esp
	acquire(&priorityQ.lock);
80103a96:	68 04 2f 11 80       	push   $0x80112f04
80103a9b:	e8 70 1d 00 00       	call   80105810 <acquire>
	if(priorityQ.sze == 0){
80103aa0:	a1 00 2f 11 80       	mov    0x80112f00,%eax
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	75 1c                	jne    80103ac8 <isEmpty+0x38>
		release(&priorityQ.lock);
80103aac:	83 ec 0c             	sub    $0xc,%esp
80103aaf:	68 04 2f 11 80       	push   $0x80112f04
80103ab4:	e8 f7 1c 00 00       	call   801057b0 <release>
		return 1;
80103ab9:	83 c4 10             	add    $0x10,%esp
80103abc:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103ac1:	c9                   	leave  
80103ac2:	c3                   	ret    
80103ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac7:	90                   	nop
		release(&priorityQ.lock);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 04 2f 11 80       	push   $0x80112f04
80103ad0:	e8 db 1c 00 00       	call   801057b0 <release>
		return 0;
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	31 c0                	xor    %eax,%eax
}
80103ada:	c9                   	leave  
80103adb:	c3                   	ret    
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <isEmpty2>:
int isEmpty2(){
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 14             	sub    $0x14,%esp
	acquire(&priorityQ2.lock);
80103ae6:	68 c4 2d 11 80       	push   $0x80112dc4
80103aeb:	e8 20 1d 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze == 0){
80103af0:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	85 c0                	test   %eax,%eax
80103afa:	75 1c                	jne    80103b18 <isEmpty2+0x38>
		release(&priorityQ2.lock);
80103afc:	83 ec 0c             	sub    $0xc,%esp
80103aff:	68 c4 2d 11 80       	push   $0x80112dc4
80103b04:	e8 a7 1c 00 00       	call   801057b0 <release>
		return 1;
80103b09:	83 c4 10             	add    $0x10,%esp
80103b0c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103b11:	c9                   	leave  
80103b12:	c3                   	ret    
80103b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b17:	90                   	nop
		release(&priorityQ2.lock);
80103b18:	83 ec 0c             	sub    $0xc,%esp
80103b1b:	68 c4 2d 11 80       	push   $0x80112dc4
80103b20:	e8 8b 1c 00 00       	call   801057b0 <release>
		return 0;
80103b25:	83 c4 10             	add    $0x10,%esp
80103b28:	31 c0                	xor    %eax,%eax
}
80103b2a:	c9                   	leave  
80103b2b:	c3                   	ret    
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b30 <isFull>:
int isFull(){
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 14             	sub    $0x14,%esp
	acquire(&priorityQ.lock);
80103b36:	68 04 2f 11 80       	push   $0x80112f04
80103b3b:	e8 d0 1c 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80103b40:	83 c4 10             	add    $0x10,%esp
80103b43:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80103b4a:	74 14                	je     80103b60 <isFull+0x30>
		release(&priorityQ.lock);
80103b4c:	83 ec 0c             	sub    $0xc,%esp
80103b4f:	68 04 2f 11 80       	push   $0x80112f04
80103b54:	e8 57 1c 00 00       	call   801057b0 <release>
		return 0;
80103b59:	83 c4 10             	add    $0x10,%esp
80103b5c:	31 c0                	xor    %eax,%eax
}
80103b5e:	c9                   	leave  
80103b5f:	c3                   	ret    
		release(&priorityQ.lock);
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	68 04 2f 11 80       	push   $0x80112f04
80103b68:	e8 43 1c 00 00       	call   801057b0 <release>
		return 1;
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103b75:	c9                   	leave  
80103b76:	c3                   	ret    
80103b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <isFull2>:
int isFull2(){
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 14             	sub    $0x14,%esp
	acquire(&priorityQ2.lock);
80103b86:	68 c4 2d 11 80       	push   $0x80112dc4
80103b8b:	e8 80 1c 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze==NPROC){
80103b90:	83 c4 10             	add    $0x10,%esp
80103b93:	83 3d c0 2d 11 80 40 	cmpl   $0x40,0x80112dc0
80103b9a:	74 14                	je     80103bb0 <isFull2+0x30>
		release(&priorityQ2.lock);
80103b9c:	83 ec 0c             	sub    $0xc,%esp
80103b9f:	68 c4 2d 11 80       	push   $0x80112dc4
80103ba4:	e8 07 1c 00 00       	call   801057b0 <release>
		return 0;
80103ba9:	83 c4 10             	add    $0x10,%esp
80103bac:	31 c0                	xor    %eax,%eax
}
80103bae:	c9                   	leave  
80103baf:	c3                   	ret    
		release(&priorityQ2.lock);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	68 c4 2d 11 80       	push   $0x80112dc4
80103bb8:	e8 f3 1b 00 00       	call   801057b0 <release>
		return 1;
80103bbd:	83 c4 10             	add    $0x10,%esp
80103bc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103bc5:	c9                   	leave  
80103bc6:	c3                   	ret    
80103bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bce:	66 90                	xchg   %ax,%ax

80103bd0 <insertIntoPQ>:
void insertIntoPQ(struct proc *p){
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 10             	sub    $0x10,%esp
80103bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&priorityQ.lock);
80103bda:	68 04 2f 11 80       	push   $0x80112f04
80103bdf:	e8 2c 1c 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80103be4:	83 c4 10             	add    $0x10,%esp
80103be7:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80103bee:	74 20                	je     80103c10 <insertIntoPQ+0x40>
		release(&priorityQ.lock);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	68 04 2f 11 80       	push   $0x80112f04
80103bf8:	e8 b3 1b 00 00       	call   801057b0 <release>
		return 0;
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	89 d8                	mov    %ebx,%eax
}
80103c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c05:	c9                   	leave  
80103c06:	e9 f5 fc ff ff       	jmp    80103900 <insertIntoPQ.part.0>
80103c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c0f:	90                   	nop
		release(&priorityQ.lock);
80103c10:	c7 45 08 04 2f 11 80 	movl   $0x80112f04,0x8(%ebp)
}
80103c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1a:	c9                   	leave  
		release(&priorityQ.lock);
80103c1b:	e9 90 1b 00 00       	jmp    801057b0 <release>

80103c20 <insertIntoPQ2>:
void insertIntoPQ2(struct proc *p){
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 10             	sub    $0x10,%esp
80103c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&priorityQ2.lock);
80103c2a:	68 c4 2d 11 80       	push   $0x80112dc4
80103c2f:	e8 dc 1b 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze==NPROC){
80103c34:	83 c4 10             	add    $0x10,%esp
80103c37:	83 3d c0 2d 11 80 40 	cmpl   $0x40,0x80112dc0
80103c3e:	74 20                	je     80103c60 <insertIntoPQ2+0x40>
		release(&priorityQ2.lock);
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 c4 2d 11 80       	push   $0x80112dc4
80103c48:	e8 63 1b 00 00       	call   801057b0 <release>
		return 0;
80103c4d:	83 c4 10             	add    $0x10,%esp
80103c50:	89 d8                	mov    %ebx,%eax
}
80103c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c55:	c9                   	leave  
80103c56:	e9 25 fd ff ff       	jmp    80103980 <insertIntoPQ2.part.0>
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop
		release(&priorityQ2.lock);
80103c60:	c7 45 08 c4 2d 11 80 	movl   $0x80112dc4,0x8(%ebp)
}
80103c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c6a:	c9                   	leave  
		release(&priorityQ2.lock);
80103c6b:	e9 40 1b 00 00       	jmp    801057b0 <release>

80103c70 <heapify>:
void heapify(int curr){
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 38             	sub    $0x38,%esp
80103c79:	8b 45 08             	mov    0x8(%ebp),%eax
	acquire(&priorityQ.lock);
80103c7c:	68 04 2f 11 80       	push   $0x80112f04
void heapify(int curr){
80103c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	acquire(&priorityQ.lock);
80103c84:	e8 87 1b 00 00       	call   80105810 <acquire>
	while(curr*2<=priorityQ.sze){
80103c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c8c:	8b 35 00 2f 11 80    	mov    0x80112f00,%esi
80103c92:	83 c4 10             	add    $0x10,%esp
80103c95:	8d 3c 00             	lea    (%eax,%eax,1),%edi
80103c98:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103c9b:	39 fe                	cmp    %edi,%esi
80103c9d:	7d 4c                	jge    80103ceb <heapify+0x7b>
80103c9f:	e9 a4 00 00 00       	jmp    80103d48 <heapify+0xd8>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if((priorityQ.proc[curr]->burst_time)<=(priorityQ.proc[curr*2]->burst_time)&&(priorityQ.proc[curr]->burst_time)<=(priorityQ.proc[curr*2+1]->burst_time))
80103ca8:	8b 0c bd 3c 2f 11 80 	mov    -0x7feed0c4(,%edi,4),%ecx
80103caf:	8d 47 01             	lea    0x1(%edi),%eax
80103cb2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80103cb5:	8b 89 84 00 00 00    	mov    0x84(%ecx),%ecx
80103cbb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80103cbe:	89 f1                	mov    %esi,%ecx
80103cc0:	8b 75 e0             	mov    -0x20(%ebp),%esi
80103cc3:	39 ce                	cmp    %ecx,%esi
80103cc5:	7f 71                	jg     80103d38 <heapify+0xc8>
80103cc7:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80103cca:	7d 7c                	jge    80103d48 <heapify+0xd8>
					priorityQ.proc[curr*2+1]=priorityQ.proc[curr];
80103ccc:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80103ccf:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103cd2:	89 1c 85 38 2f 11 80 	mov    %ebx,-0x7feed0c8(,%eax,4)
					priorityQ.proc[curr]=temp;
80103cd9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
	while(curr*2<=priorityQ.sze){
80103cdc:	8d 3c 00             	lea    (%eax,%eax,1),%edi
					priorityQ.proc[curr]=temp;
80103cdf:	89 14 9d 08 2f 11 80 	mov    %edx,-0x7feed0f8(,%ebx,4)
	while(curr*2<=priorityQ.sze){
80103ce6:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80103ce9:	7f 5d                	jg     80103d48 <heapify+0xd8>
			if((priorityQ.proc[curr]->burst_time)<=(priorityQ.proc[curr*2]->burst_time)&&(priorityQ.proc[curr]->burst_time)<=(priorityQ.proc[curr*2+1]->burst_time))
80103ceb:	83 c0 0c             	add    $0xc,%eax
80103cee:	8d 5f 0c             	lea    0xc(%edi),%ebx
80103cf1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103cf4:	8b 14 9d 08 2f 11 80 	mov    -0x7feed0f8(,%ebx,4),%edx
80103cfb:	8b 04 85 08 2f 11 80 	mov    -0x7feed0f8(,%eax,4),%eax
80103d02:	8b b2 84 00 00 00    	mov    0x84(%edx),%esi
80103d08:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103d0b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80103d11:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80103d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(curr*2+1<=priorityQ.sze){
80103d17:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80103d1a:	7c 8c                	jl     80103ca8 <heapify+0x38>
			if((priorityQ.proc[curr]->burst_time)<=(priorityQ.proc[curr*2]->burst_time))
80103d1c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80103d1f:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
80103d22:	7e 24                	jle    80103d48 <heapify+0xd8>
				priorityQ.proc[curr*2]=priorityQ.proc[curr];
80103d24:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d27:	89 04 9d 08 2f 11 80 	mov    %eax,-0x7feed0f8(,%ebx,4)
80103d2e:	89 f8                	mov    %edi,%eax
80103d30:	eb a7                	jmp    80103cd9 <heapify+0x69>
80103d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				if((priorityQ.proc[curr*2]->burst_time)<=(priorityQ.proc[curr*2+1]->burst_time)){
80103d38:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80103d3b:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80103d3e:	7d e4                	jge    80103d24 <heapify+0xb4>
80103d40:	eb 8a                	jmp    80103ccc <heapify+0x5c>
80103d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	release(&priorityQ.lock);
80103d48:	c7 45 08 04 2f 11 80 	movl   $0x80112f04,0x8(%ebp)
}
80103d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d52:	5b                   	pop    %ebx
80103d53:	5e                   	pop    %esi
80103d54:	5f                   	pop    %edi
80103d55:	5d                   	pop    %ebp
	release(&priorityQ.lock);
80103d56:	e9 55 1a 00 00       	jmp    801057b0 <release>
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <heapify2>:
void heapify2(int curr){
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 38             	sub    $0x38,%esp
80103d69:	8b 45 08             	mov    0x8(%ebp),%eax
	acquire(&priorityQ2.lock);
80103d6c:	68 c4 2d 11 80       	push   $0x80112dc4
void heapify2(int curr){
80103d71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	acquire(&priorityQ2.lock);
80103d74:	e8 97 1a 00 00       	call   80105810 <acquire>
	while(curr*2<=priorityQ2.sze){
80103d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d7c:	8b 35 c0 2d 11 80    	mov    0x80112dc0,%esi
80103d82:	83 c4 10             	add    $0x10,%esp
80103d85:	8d 3c 00             	lea    (%eax,%eax,1),%edi
80103d88:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103d8b:	39 fe                	cmp    %edi,%esi
80103d8d:	7d 4c                	jge    80103ddb <heapify2+0x7b>
80103d8f:	e9 a4 00 00 00       	jmp    80103e38 <heapify2+0xd8>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if((priorityQ2.proc[curr]->burst_time)<=(priorityQ2.proc[curr*2]->burst_time)&&(priorityQ2.proc[curr]->burst_time)<=(priorityQ2.proc[curr*2+1]->burst_time))
80103d98:	8b 0c bd fc 2d 11 80 	mov    -0x7feed204(,%edi,4),%ecx
80103d9f:	8d 47 01             	lea    0x1(%edi),%eax
80103da2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80103da5:	8b 89 84 00 00 00    	mov    0x84(%ecx),%ecx
80103dab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80103dae:	89 f1                	mov    %esi,%ecx
80103db0:	8b 75 e0             	mov    -0x20(%ebp),%esi
80103db3:	39 ce                	cmp    %ecx,%esi
80103db5:	7f 71                	jg     80103e28 <heapify2+0xc8>
80103db7:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80103dba:	7d 7c                	jge    80103e38 <heapify2+0xd8>
					priorityQ2.proc[curr*2+1]=priorityQ2.proc[curr];
80103dbc:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80103dbf:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103dc2:	89 1c 85 f8 2d 11 80 	mov    %ebx,-0x7feed208(,%eax,4)
					priorityQ2.proc[curr]=temp;
80103dc9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
	while(curr*2<=priorityQ2.sze){
80103dcc:	8d 3c 00             	lea    (%eax,%eax,1),%edi
					priorityQ2.proc[curr]=temp;
80103dcf:	89 14 9d c8 2d 11 80 	mov    %edx,-0x7feed238(,%ebx,4)
	while(curr*2<=priorityQ2.sze){
80103dd6:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80103dd9:	7f 5d                	jg     80103e38 <heapify2+0xd8>
			if((priorityQ2.proc[curr]->burst_time)<=(priorityQ2.proc[curr*2]->burst_time)&&(priorityQ2.proc[curr]->burst_time)<=(priorityQ2.proc[curr*2+1]->burst_time))
80103ddb:	83 c0 0c             	add    $0xc,%eax
80103dde:	8d 5f 0c             	lea    0xc(%edi),%ebx
80103de1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103de4:	8b 14 9d c8 2d 11 80 	mov    -0x7feed238(,%ebx,4),%edx
80103deb:	8b 04 85 c8 2d 11 80 	mov    -0x7feed238(,%eax,4),%eax
80103df2:	8b b2 84 00 00 00    	mov    0x84(%edx),%esi
80103df8:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103dfb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80103e01:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80103e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(curr*2+1<=priorityQ2.sze){
80103e07:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80103e0a:	7c 8c                	jl     80103d98 <heapify2+0x38>
			if((priorityQ2.proc[curr]->burst_time)<=(priorityQ2.proc[curr*2]->burst_time))
80103e0c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80103e0f:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
80103e12:	7e 24                	jle    80103e38 <heapify2+0xd8>
				priorityQ2.proc[curr*2]=priorityQ2.proc[curr];
80103e14:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e17:	89 04 9d c8 2d 11 80 	mov    %eax,-0x7feed238(,%ebx,4)
80103e1e:	89 f8                	mov    %edi,%eax
80103e20:	eb a7                	jmp    80103dc9 <heapify2+0x69>
80103e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				if((priorityQ2.proc[curr*2]->burst_time)<=(priorityQ2.proc[curr*2+1]->burst_time)){
80103e28:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80103e2b:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80103e2e:	7d e4                	jge    80103e14 <heapify2+0xb4>
80103e30:	eb 8a                	jmp    80103dbc <heapify2+0x5c>
80103e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	release(&priorityQ2.lock);
80103e38:	c7 45 08 c4 2d 11 80 	movl   $0x80112dc4,0x8(%ebp)
}
80103e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e42:	5b                   	pop    %ebx
80103e43:	5e                   	pop    %esi
80103e44:	5f                   	pop    %edi
80103e45:	5d                   	pop    %ebp
	release(&priorityQ2.lock);
80103e46:	e9 65 19 00 00       	jmp    801057b0 <release>
80103e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <extractMin>:
struct proc * extractMin(){
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 10             	sub    $0x10,%esp
	acquire(&priorityQ.lock);
80103e57:	68 04 2f 11 80       	push   $0x80112f04
80103e5c:	e8 af 19 00 00       	call   80105810 <acquire>
	if(priorityQ.sze == 0){
80103e61:	a1 00 2f 11 80       	mov    0x80112f00,%eax
80103e66:	83 c4 10             	add    $0x10,%esp
80103e69:	85 c0                	test   %eax,%eax
80103e6b:	75 23                	jne    80103e90 <extractMin+0x40>
		release(&priorityQ.lock);
80103e6d:	83 ec 0c             	sub    $0xc,%esp
		return 0;
80103e70:	31 db                	xor    %ebx,%ebx
		release(&priorityQ.lock);
80103e72:	68 04 2f 11 80       	push   $0x80112f04
80103e77:	e8 34 19 00 00       	call   801057b0 <release>
}
80103e7c:	89 d8                	mov    %ebx,%eax
		release(&priorityQ.lock);
80103e7e:	83 c4 10             	add    $0x10,%esp
}
80103e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e84:	c9                   	leave  
80103e85:	c3                   	ret    
80103e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 04 2f 11 80       	push   $0x80112f04
80103e98:	e8 13 19 00 00       	call   801057b0 <release>
	acquire(&priorityQ.lock);
80103e9d:	c7 04 24 04 2f 11 80 	movl   $0x80112f04,(%esp)
80103ea4:	e8 67 19 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==1)
80103ea9:	a1 00 2f 11 80       	mov    0x80112f00,%eax
	struct proc* minimum=priorityQ.proc[1];
80103eae:	8b 1d 3c 2f 11 80    	mov    0x80112f3c,%ebx
	if(priorityQ.sze==1)
80103eb4:	83 c4 10             	add    $0x10,%esp
80103eb7:	83 f8 01             	cmp    $0x1,%eax
80103eba:	74 3c                	je     80103ef8 <extractMin+0xa8>
		release(&priorityQ.lock);
80103ebc:	83 ec 0c             	sub    $0xc,%esp
		priorityQ.proc[1] = priorityQ.proc[priorityQ.sze];
80103ebf:	8b 14 85 38 2f 11 80 	mov    -0x7feed0c8(,%eax,4),%edx
		priorityQ.sze--;
80103ec6:	83 e8 01             	sub    $0x1,%eax
		release(&priorityQ.lock);
80103ec9:	68 04 2f 11 80       	push   $0x80112f04
		priorityQ.sze--;
80103ece:	a3 00 2f 11 80       	mov    %eax,0x80112f00
		priorityQ.proc[1] = priorityQ.proc[priorityQ.sze];
80103ed3:	89 15 3c 2f 11 80    	mov    %edx,0x80112f3c
		release(&priorityQ.lock);
80103ed9:	e8 d2 18 00 00       	call   801057b0 <release>
		heapify(1);
80103ede:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ee5:	e8 86 fd ff ff       	call   80103c70 <heapify>
}
80103eea:	89 d8                	mov    %ebx,%eax
		heapify(1);
80103eec:	83 c4 10             	add    $0x10,%esp
}
80103eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef2:	c9                   	leave  
80103ef3:	c3                   	ret    
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		priorityQ.sze=0;
80103ef8:	c7 05 00 2f 11 80 00 	movl   $0x0,0x80112f00
80103eff:	00 00 00 
		release(&priorityQ.lock);
80103f02:	83 ec 0c             	sub    $0xc,%esp
80103f05:	68 04 2f 11 80       	push   $0x80112f04
80103f0a:	e8 a1 18 00 00       	call   801057b0 <release>
}
80103f0f:	89 d8                	mov    %ebx,%eax
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f17:	c9                   	leave  
80103f18:	c3                   	ret    
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f20 <extractMin2>:
struct proc * extractMin2(){
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 10             	sub    $0x10,%esp
	acquire(&priorityQ2.lock);
80103f27:	68 c4 2d 11 80       	push   $0x80112dc4
80103f2c:	e8 df 18 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze == 0){
80103f31:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
80103f36:	83 c4 10             	add    $0x10,%esp
80103f39:	85 c0                	test   %eax,%eax
80103f3b:	75 23                	jne    80103f60 <extractMin2+0x40>
		release(&priorityQ2.lock);
80103f3d:	83 ec 0c             	sub    $0xc,%esp
		return 0;
80103f40:	31 db                	xor    %ebx,%ebx
		release(&priorityQ2.lock);
80103f42:	68 c4 2d 11 80       	push   $0x80112dc4
80103f47:	e8 64 18 00 00       	call   801057b0 <release>
}
80103f4c:	89 d8                	mov    %ebx,%eax
		release(&priorityQ2.lock);
80103f4e:	83 c4 10             	add    $0x10,%esp
}
80103f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f54:	c9                   	leave  
80103f55:	c3                   	ret    
80103f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ2.lock);
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	68 c4 2d 11 80       	push   $0x80112dc4
80103f68:	e8 43 18 00 00       	call   801057b0 <release>
	acquire(&priorityQ2.lock);
80103f6d:	c7 04 24 c4 2d 11 80 	movl   $0x80112dc4,(%esp)
80103f74:	e8 97 18 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze==1)
80103f79:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
	struct proc* minimum=priorityQ2.proc[1];
80103f7e:	8b 1d fc 2d 11 80    	mov    0x80112dfc,%ebx
	if(priorityQ2.sze==1)
80103f84:	83 c4 10             	add    $0x10,%esp
80103f87:	83 f8 01             	cmp    $0x1,%eax
80103f8a:	74 3c                	je     80103fc8 <extractMin2+0xa8>
		release(&priorityQ2.lock);
80103f8c:	83 ec 0c             	sub    $0xc,%esp
		priorityQ2.proc[1] = priorityQ2.proc[priorityQ2.sze];
80103f8f:	8b 14 85 f8 2d 11 80 	mov    -0x7feed208(,%eax,4),%edx
		priorityQ2.sze--;
80103f96:	83 e8 01             	sub    $0x1,%eax
		release(&priorityQ2.lock);
80103f99:	68 c4 2d 11 80       	push   $0x80112dc4
		priorityQ2.sze--;
80103f9e:	a3 c0 2d 11 80       	mov    %eax,0x80112dc0
		priorityQ2.proc[1] = priorityQ2.proc[priorityQ2.sze];
80103fa3:	89 15 fc 2d 11 80    	mov    %edx,0x80112dfc
		release(&priorityQ2.lock);
80103fa9:	e8 02 18 00 00       	call   801057b0 <release>
		heapify2(1);
80103fae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103fb5:	e8 a6 fd ff ff       	call   80103d60 <heapify2>
}
80103fba:	89 d8                	mov    %ebx,%eax
		heapify2(1);
80103fbc:	83 c4 10             	add    $0x10,%esp
}
80103fbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc2:	c9                   	leave  
80103fc3:	c3                   	ret    
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		priorityQ2.sze=0;
80103fc8:	c7 05 c0 2d 11 80 00 	movl   $0x0,0x80112dc0
80103fcf:	00 00 00 
		release(&priorityQ2.lock);
80103fd2:	83 ec 0c             	sub    $0xc,%esp
80103fd5:	68 c4 2d 11 80       	push   $0x80112dc4
80103fda:	e8 d1 17 00 00       	call   801057b0 <release>
}
80103fdf:	89 d8                	mov    %ebx,%eax
80103fe1:	83 c4 10             	add    $0x10,%esp
80103fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe7:	c9                   	leave  
80103fe8:	c3                   	ret    
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <changeKey>:
void changeKey(int pid, int newBT){
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 28             	sub    $0x28,%esp
80103ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
	acquire(&priorityQ.lock);
80103fff:	68 04 2f 11 80       	push   $0x80112f04
void changeKey(int pid, int newBT){
80104004:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	acquire(&priorityQ.lock);
80104007:	e8 04 18 00 00       	call   80105810 <acquire>
	for(int i=1;i<=priorityQ.sze;i++){
8010400c:	a1 00 2f 11 80       	mov    0x80112f00,%eax
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	85 c0                	test   %eax,%eax
80104016:	0f 8e a4 00 00 00    	jle    801040c0 <changeKey+0xd0>
8010401c:	bb 01 00 00 00       	mov    $0x1,%ebx
80104021:	eb 10                	jmp    80104033 <changeKey+0x43>
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
80104028:	83 c3 01             	add    $0x1,%ebx
8010402b:	39 c3                	cmp    %eax,%ebx
8010402d:	0f 8f 8d 00 00 00    	jg     801040c0 <changeKey+0xd0>
		if(priorityQ.proc[i]->pid == pid){
80104033:	8b 34 9d 38 2f 11 80 	mov    -0x7feed0c8(,%ebx,4),%esi
8010403a:	39 7e 10             	cmp    %edi,0x10(%esi)
8010403d:	75 e9                	jne    80104028 <changeKey+0x38>
		priorityQ.sze--;
8010403f:	8d 50 ff             	lea    -0x1(%eax),%edx
	if(curr==priorityQ.sze){
80104042:	39 c3                	cmp    %eax,%ebx
80104044:	0f 84 8e 00 00 00    	je     801040d8 <changeKey+0xe8>
		release(&priorityQ.lock);
8010404a:	83 ec 0c             	sub    $0xc,%esp
		priorityQ.proc[curr]=priorityQ.proc[priorityQ.sze];
8010404d:	8b 04 85 38 2f 11 80 	mov    -0x7feed0c8(,%eax,4),%eax
		priorityQ.sze--;
80104054:	89 15 00 2f 11 80    	mov    %edx,0x80112f00
		release(&priorityQ.lock);
8010405a:	68 04 2f 11 80       	push   $0x80112f04
		priorityQ.proc[curr]=priorityQ.proc[priorityQ.sze];
8010405f:	89 04 9d 38 2f 11 80 	mov    %eax,-0x7feed0c8(,%ebx,4)
		release(&priorityQ.lock);
80104066:	e8 45 17 00 00       	call   801057b0 <release>
		heapify(curr);
8010406b:	89 1c 24             	mov    %ebx,(%esp)
8010406e:	e8 fd fb ff ff       	call   80103c70 <heapify>
80104073:	83 c4 10             	add    $0x10,%esp
	p->burst_time=newBT;
80104076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	acquire(&priorityQ.lock);
80104079:	83 ec 0c             	sub    $0xc,%esp
	p->burst_time=newBT;
8010407c:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	acquire(&priorityQ.lock);
80104082:	68 04 2f 11 80       	push   $0x80112f04
80104087:	e8 84 17 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
8010408c:	83 c4 10             	add    $0x10,%esp
8010408f:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80104096:	74 28                	je     801040c0 <changeKey+0xd0>
		release(&priorityQ.lock);
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 04 2f 11 80       	push   $0x80112f04
801040a0:	e8 0b 17 00 00       	call   801057b0 <release>
		return 0;
801040a5:	83 c4 10             	add    $0x10,%esp
}
801040a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ab:	89 f0                	mov    %esi,%eax
801040ad:	5b                   	pop    %ebx
801040ae:	5e                   	pop    %esi
801040af:	5f                   	pop    %edi
801040b0:	5d                   	pop    %ebp
801040b1:	e9 4a f8 ff ff       	jmp    80103900 <insertIntoPQ.part.0>
801040b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
801040c0:	c7 45 08 04 2f 11 80 	movl   $0x80112f04,0x8(%ebp)
}
801040c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ca:	5b                   	pop    %ebx
801040cb:	5e                   	pop    %esi
801040cc:	5f                   	pop    %edi
801040cd:	5d                   	pop    %ebp
		release(&priorityQ.lock);
801040ce:	e9 dd 16 00 00       	jmp    801057b0 <release>
801040d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d7:	90                   	nop
		release(&priorityQ.lock);
801040d8:	83 ec 0c             	sub    $0xc,%esp
		priorityQ.sze--;
801040db:	89 15 00 2f 11 80    	mov    %edx,0x80112f00
		release(&priorityQ.lock);
801040e1:	68 04 2f 11 80       	push   $0x80112f04
801040e6:	e8 c5 16 00 00       	call   801057b0 <release>
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	eb 86                	jmp    80104076 <changeKey+0x86>

801040f0 <changeKey2>:
void changeKey2(int pid, int newBT){
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 28             	sub    $0x28,%esp
801040f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fc:	8b 7d 08             	mov    0x8(%ebp),%edi
	acquire(&priorityQ2.lock);
801040ff:	68 c4 2d 11 80       	push   $0x80112dc4
void changeKey2(int pid, int newBT){
80104104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	acquire(&priorityQ2.lock);
80104107:	e8 04 17 00 00       	call   80105810 <acquire>
	for(int i=1;i<=priorityQ2.sze;i++){
8010410c:	a1 c0 2d 11 80       	mov    0x80112dc0,%eax
80104111:	83 c4 10             	add    $0x10,%esp
80104114:	85 c0                	test   %eax,%eax
80104116:	0f 8e a4 00 00 00    	jle    801041c0 <changeKey2+0xd0>
8010411c:	bb 01 00 00 00       	mov    $0x1,%ebx
80104121:	eb 10                	jmp    80104133 <changeKey2+0x43>
80104123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104127:	90                   	nop
80104128:	83 c3 01             	add    $0x1,%ebx
8010412b:	39 c3                	cmp    %eax,%ebx
8010412d:	0f 8f 8d 00 00 00    	jg     801041c0 <changeKey2+0xd0>
		if(priorityQ2.proc[i]->pid == pid){
80104133:	8b 34 9d f8 2d 11 80 	mov    -0x7feed208(,%ebx,4),%esi
8010413a:	39 7e 10             	cmp    %edi,0x10(%esi)
8010413d:	75 e9                	jne    80104128 <changeKey2+0x38>
		priorityQ2.sze--;
8010413f:	8d 50 ff             	lea    -0x1(%eax),%edx
	if(curr==priorityQ2.sze){
80104142:	39 c3                	cmp    %eax,%ebx
80104144:	0f 84 8e 00 00 00    	je     801041d8 <changeKey2+0xe8>
		release(&priorityQ2.lock);
8010414a:	83 ec 0c             	sub    $0xc,%esp
		priorityQ2.proc[curr]=priorityQ2.proc[priorityQ2.sze];
8010414d:	8b 04 85 f8 2d 11 80 	mov    -0x7feed208(,%eax,4),%eax
		priorityQ2.sze--;
80104154:	89 15 c0 2d 11 80    	mov    %edx,0x80112dc0
		release(&priorityQ2.lock);
8010415a:	68 c4 2d 11 80       	push   $0x80112dc4
		priorityQ2.proc[curr]=priorityQ2.proc[priorityQ2.sze];
8010415f:	89 04 9d f8 2d 11 80 	mov    %eax,-0x7feed208(,%ebx,4)
		release(&priorityQ2.lock);
80104166:	e8 45 16 00 00       	call   801057b0 <release>
		heapify2(curr);
8010416b:	89 1c 24             	mov    %ebx,(%esp)
8010416e:	e8 ed fb ff ff       	call   80103d60 <heapify2>
80104173:	83 c4 10             	add    $0x10,%esp
	p->burst_time=newBT;
80104176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	acquire(&priorityQ2.lock);
80104179:	83 ec 0c             	sub    $0xc,%esp
	p->burst_time=newBT;
8010417c:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	acquire(&priorityQ2.lock);
80104182:	68 c4 2d 11 80       	push   $0x80112dc4
80104187:	e8 84 16 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze==NPROC){
8010418c:	83 c4 10             	add    $0x10,%esp
8010418f:	83 3d c0 2d 11 80 40 	cmpl   $0x40,0x80112dc0
80104196:	74 28                	je     801041c0 <changeKey2+0xd0>
		release(&priorityQ2.lock);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 c4 2d 11 80       	push   $0x80112dc4
801041a0:	e8 0b 16 00 00       	call   801057b0 <release>
		return 0;
801041a5:	83 c4 10             	add    $0x10,%esp
}
801041a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ab:	89 f0                	mov    %esi,%eax
801041ad:	5b                   	pop    %ebx
801041ae:	5e                   	pop    %esi
801041af:	5f                   	pop    %edi
801041b0:	5d                   	pop    %ebp
801041b1:	e9 ca f7 ff ff       	jmp    80103980 <insertIntoPQ2.part.0>
801041b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ2.lock);
801041c0:	c7 45 08 c4 2d 11 80 	movl   $0x80112dc4,0x8(%ebp)
}
801041c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5f                   	pop    %edi
801041cd:	5d                   	pop    %ebp
		release(&priorityQ2.lock);
801041ce:	e9 dd 15 00 00       	jmp    801057b0 <release>
801041d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d7:	90                   	nop
		release(&priorityQ2.lock);
801041d8:	83 ec 0c             	sub    $0xc,%esp
		priorityQ2.sze--;
801041db:	89 15 c0 2d 11 80    	mov    %edx,0x80112dc0
		release(&priorityQ2.lock);
801041e1:	68 c4 2d 11 80       	push   $0x80112dc4
801041e6:	e8 c5 15 00 00       	call   801057b0 <release>
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	eb 86                	jmp    80104176 <changeKey2+0x86>

801041f0 <pinit>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801041f6:	68 60 8b 10 80       	push   $0x80108b60
801041fb:	68 40 30 11 80       	push   $0x80113040
80104200:	e8 3b 14 00 00       	call   80105640 <initlock>
  initlock(&priorityQ.lock, "priorityQ");
80104205:	58                   	pop    %eax
80104206:	5a                   	pop    %edx
80104207:	68 67 8b 10 80       	push   $0x80108b67
8010420c:	68 04 2f 11 80       	push   $0x80112f04
80104211:	e8 2a 14 00 00       	call   80105640 <initlock>
  initlock(&priorityQ2.lock, "priorityQ2");
80104216:	59                   	pop    %ecx
80104217:	58                   	pop    %eax
80104218:	68 71 8b 10 80       	push   $0x80108b71
8010421d:	68 c4 2d 11 80       	push   $0x80112dc4
80104222:	e8 19 14 00 00       	call   80105640 <initlock>
}
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	c9                   	leave  
8010422b:	c3                   	ret    
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <mycpu>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104235:	9c                   	pushf  
80104236:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104237:	f6 c4 02             	test   $0x2,%ah
8010423a:	75 46                	jne    80104282 <mycpu+0x52>
  apicid = lapicid();
8010423c:	e8 af e6 ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104241:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80104247:	85 f6                	test   %esi,%esi
80104249:	7e 2a                	jle    80104275 <mycpu+0x45>
8010424b:	31 d2                	xor    %edx,%edx
8010424d:	eb 08                	jmp    80104257 <mycpu+0x27>
8010424f:	90                   	nop
80104250:	83 c2 01             	add    $0x1,%edx
80104253:	39 f2                	cmp    %esi,%edx
80104255:	74 1e                	je     80104275 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104257:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010425d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80104264:	39 c3                	cmp    %eax,%ebx
80104266:	75 e8                	jne    80104250 <mycpu+0x20>
}
80104268:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010426b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80104271:	5b                   	pop    %ebx
80104272:	5e                   	pop    %esi
80104273:	5d                   	pop    %ebp
80104274:	c3                   	ret    
  panic("unknown apicid\n");
80104275:	83 ec 0c             	sub    $0xc,%esp
80104278:	68 7c 8b 10 80       	push   $0x80108b7c
8010427d:	e8 fe c0 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104282:	83 ec 0c             	sub    $0xc,%esp
80104285:	68 58 8c 10 80       	push   $0x80108c58
8010428a:	e8 f1 c0 ff ff       	call   80100380 <panic>
8010428f:	90                   	nop

80104290 <cpuid>:
cpuid() {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104296:	e8 95 ff ff ff       	call   80104230 <mycpu>
}
8010429b:	c9                   	leave  
  return mycpu()-cpus;
8010429c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801042a1:	c1 f8 04             	sar    $0x4,%eax
801042a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042aa:	c3                   	ret    
801042ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop

801042b0 <myproc>:
myproc(void) {
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042b7:	e8 04 14 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801042bc:	e8 6f ff ff ff       	call   80104230 <mycpu>
  p = c->proc;
801042c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c7:	e8 44 14 00 00       	call   80105710 <popcli>
}
801042cc:	89 d8                	mov    %ebx,%eax
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave  
801042d2:	c3                   	ret    
801042d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042e0 <userinit>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&priorityQ.lock);
801042e7:	68 04 2f 11 80       	push   $0x80112f04
801042ec:	e8 1f 15 00 00       	call   80105810 <acquire>
  release(&priorityQ.lock);
801042f1:	c7 04 24 04 2f 11 80 	movl   $0x80112f04,(%esp)
  priorityQ2.sze = 0;
801042f8:	c7 05 c0 2d 11 80 00 	movl   $0x0,0x80112dc0
801042ff:	00 00 00 
  release(&priorityQ.lock);
80104302:	e8 a9 14 00 00       	call   801057b0 <release>
  acquire(&priorityQ2.lock);
80104307:	c7 04 24 c4 2d 11 80 	movl   $0x80112dc4,(%esp)
8010430e:	e8 fd 14 00 00       	call   80105810 <acquire>
  release(&priorityQ2.lock);
80104313:	c7 04 24 c4 2d 11 80 	movl   $0x80112dc4,(%esp)
  priorityQ2.sze = 0;
8010431a:	c7 05 c0 2d 11 80 00 	movl   $0x0,0x80112dc0
80104321:	00 00 00 
  release(&priorityQ2.lock);
80104324:	e8 87 14 00 00       	call   801057b0 <release>
  p = allocproc();
80104329:	e8 82 f4 ff ff       	call   801037b0 <allocproc>
8010432e:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104330:	a3 74 53 11 80       	mov    %eax,0x80115374
  if((p->pgdir = setupkvm()) == 0)
80104335:	e8 86 3f 00 00       	call   801082c0 <setupkvm>
8010433a:	83 c4 10             	add    $0x10,%esp
8010433d:	89 43 04             	mov    %eax,0x4(%ebx)
80104340:	85 c0                	test   %eax,%eax
80104342:	0f 84 1a 01 00 00    	je     80104462 <userinit+0x182>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104348:	83 ec 04             	sub    $0x4,%esp
8010434b:	68 2c 00 00 00       	push   $0x2c
80104350:	68 60 b4 10 80       	push   $0x8010b460
80104355:	50                   	push   %eax
80104356:	e8 15 3c 00 00       	call   80107f70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010435b:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010435e:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104364:	6a 4c                	push   $0x4c
80104366:	6a 00                	push   $0x0
80104368:	ff 73 18             	push   0x18(%ebx)
8010436b:	e8 60 15 00 00       	call   801058d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104370:	8b 43 18             	mov    0x18(%ebx),%eax
80104373:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104378:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010437b:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104380:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104384:	8b 43 18             	mov    0x18(%ebx),%eax
80104387:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010438b:	8b 43 18             	mov    0x18(%ebx),%eax
8010438e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104392:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104396:	8b 43 18             	mov    0x18(%ebx),%eax
80104399:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010439d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801043a1:	8b 43 18             	mov    0x18(%ebx),%eax
801043a4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043ab:	8b 43 18             	mov    0x18(%ebx),%eax
801043ae:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043b5:	8b 43 18             	mov    0x18(%ebx),%eax
801043b8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801043bf:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043c2:	6a 10                	push   $0x10
801043c4:	68 a5 8b 10 80       	push   $0x80108ba5
801043c9:	50                   	push   %eax
801043ca:	e8 c1 16 00 00       	call   80105a90 <safestrcpy>
  p->cwd = namei("/");
801043cf:	c7 04 24 ae 8b 10 80 	movl   $0x80108bae,(%esp)
801043d6:	e8 c5 dc ff ff       	call   801020a0 <namei>
801043db:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043de:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
801043e5:	e8 26 14 00 00       	call   80105810 <acquire>
  short check = (p->state!=RUNNABLE);
801043ea:	8b 43 0c             	mov    0xc(%ebx),%eax
  if(check)
801043ed:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
801043f0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(check)
801043f7:	83 f8 03             	cmp    $0x3,%eax
801043fa:	75 1c                	jne    80104418 <userinit+0x138>
  release(&ptable.lock);
801043fc:	83 ec 0c             	sub    $0xc,%esp
801043ff:	68 40 30 11 80       	push   $0x80113040
80104404:	e8 a7 13 00 00       	call   801057b0 <release>
}
80104409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	c9                   	leave  
80104410:	c3                   	ret    
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	acquire(&priorityQ.lock);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 04 2f 11 80       	push   $0x80112f04
80104420:	e8 eb 13 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80104425:	83 c4 10             	add    $0x10,%esp
80104428:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
8010442f:	74 1f                	je     80104450 <userinit+0x170>
		release(&priorityQ.lock);
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 04 2f 11 80       	push   $0x80112f04
80104439:	e8 72 13 00 00       	call   801057b0 <release>
		return 0;
8010443e:	89 d8                	mov    %ebx,%eax
80104440:	e8 bb f4 ff ff       	call   80103900 <insertIntoPQ.part.0>
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	eb b2                	jmp    801043fc <userinit+0x11c>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 04 2f 11 80       	push   $0x80112f04
80104458:	e8 53 13 00 00       	call   801057b0 <release>
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	eb 9a                	jmp    801043fc <userinit+0x11c>
    panic("userinit: out of memory?");
80104462:	83 ec 0c             	sub    $0xc,%esp
80104465:	68 8c 8b 10 80       	push   $0x80108b8c
8010446a:	e8 11 bf ff ff       	call   80100380 <panic>
8010446f:	90                   	nop

80104470 <growproc>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104478:	e8 43 12 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010447d:	e8 ae fd ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104482:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104488:	e8 83 12 00 00       	call   80105710 <popcli>
  sz = curproc->sz;
8010448d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010448f:	85 f6                	test   %esi,%esi
80104491:	7f 1d                	jg     801044b0 <growproc+0x40>
  } else if(n < 0){
80104493:	75 3b                	jne    801044d0 <growproc+0x60>
  switchuvm(curproc);
80104495:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104498:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010449a:	53                   	push   %ebx
8010449b:	e8 c0 39 00 00       	call   80107e60 <switchuvm>
  return 0;
801044a0:	83 c4 10             	add    $0x10,%esp
801044a3:	31 c0                	xor    %eax,%eax
}
801044a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a8:	5b                   	pop    %ebx
801044a9:	5e                   	pop    %esi
801044aa:	5d                   	pop    %ebp
801044ab:	c3                   	ret    
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801044b0:	83 ec 04             	sub    $0x4,%esp
801044b3:	01 c6                	add    %eax,%esi
801044b5:	56                   	push   %esi
801044b6:	50                   	push   %eax
801044b7:	ff 73 04             	push   0x4(%ebx)
801044ba:	e8 21 3c 00 00       	call   801080e0 <allocuvm>
801044bf:	83 c4 10             	add    $0x10,%esp
801044c2:	85 c0                	test   %eax,%eax
801044c4:	75 cf                	jne    80104495 <growproc+0x25>
      return -1;
801044c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044cb:	eb d8                	jmp    801044a5 <growproc+0x35>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801044d0:	83 ec 04             	sub    $0x4,%esp
801044d3:	01 c6                	add    %eax,%esi
801044d5:	56                   	push   %esi
801044d6:	50                   	push   %eax
801044d7:	ff 73 04             	push   0x4(%ebx)
801044da:	e8 31 3d 00 00       	call   80108210 <deallocuvm>
801044df:	83 c4 10             	add    $0x10,%esp
801044e2:	85 c0                	test   %eax,%eax
801044e4:	75 af                	jne    80104495 <growproc+0x25>
801044e6:	eb de                	jmp    801044c6 <growproc+0x56>
801044e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ef:	90                   	nop

801044f0 <fork>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801044f9:	e8 c2 11 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801044fe:	e8 2d fd ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104503:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104509:	e8 02 12 00 00       	call   80105710 <popcli>
  if((np = allocproc()) == 0){
8010450e:	e8 9d f2 ff ff       	call   801037b0 <allocproc>
80104513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104516:	85 c0                	test   %eax,%eax
80104518:	0f 84 0f 01 00 00    	je     8010462d <fork+0x13d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010451e:	83 ec 08             	sub    $0x8,%esp
80104521:	ff 33                	push   (%ebx)
80104523:	89 c7                	mov    %eax,%edi
80104525:	ff 73 04             	push   0x4(%ebx)
80104528:	e8 83 3e 00 00       	call   801083b0 <copyuvm>
8010452d:	83 c4 10             	add    $0x10,%esp
80104530:	89 47 04             	mov    %eax,0x4(%edi)
80104533:	85 c0                	test   %eax,%eax
80104535:	0f 84 f9 00 00 00    	je     80104634 <fork+0x144>
  np->sz = curproc->sz;
8010453b:	8b 03                	mov    (%ebx),%eax
8010453d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104540:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104542:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104545:	89 c8                	mov    %ecx,%eax
80104547:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010454a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010454f:	8b 73 18             	mov    0x18(%ebx),%esi
80104552:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104554:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104556:	8b 40 18             	mov    0x18(%eax),%eax
80104559:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104560:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104564:	85 c0                	test   %eax,%eax
80104566:	74 13                	je     8010457b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	50                   	push   %eax
8010456c:	e8 2f c9 ff ff       	call   80100ea0 <filedup>
80104571:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104574:	83 c4 10             	add    $0x10,%esp
80104577:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010457b:	83 c6 01             	add    $0x1,%esi
8010457e:	83 fe 10             	cmp    $0x10,%esi
80104581:	75 dd                	jne    80104560 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104583:	83 ec 0c             	sub    $0xc,%esp
80104586:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104589:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010458c:	e8 bf d1 ff ff       	call   80101750 <idup>
80104591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104594:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104597:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010459a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010459d:	6a 10                	push   $0x10
8010459f:	53                   	push   %ebx
801045a0:	50                   	push   %eax
801045a1:	e8 ea 14 00 00       	call   80105a90 <safestrcpy>
  pid = np->pid;
801045a6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801045a9:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
801045b0:	e8 5b 12 00 00       	call   80105810 <acquire>
  short check = (np->state!=RUNNABLE);
801045b5:	8b 47 0c             	mov    0xc(%edi),%eax
  if(check)
801045b8:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801045bb:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  if(check)
801045c2:	83 f8 03             	cmp    $0x3,%eax
801045c5:	75 21                	jne    801045e8 <fork+0xf8>
  release(&ptable.lock);
801045c7:	83 ec 0c             	sub    $0xc,%esp
801045ca:	68 40 30 11 80       	push   $0x80113040
801045cf:	e8 dc 11 00 00       	call   801057b0 <release>
  return pid;
801045d4:	83 c4 10             	add    $0x10,%esp
}
801045d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045da:	89 d8                	mov    %ebx,%eax
801045dc:	5b                   	pop    %ebx
801045dd:	5e                   	pop    %esi
801045de:	5f                   	pop    %edi
801045df:	5d                   	pop    %ebp
801045e0:	c3                   	ret    
801045e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	acquire(&priorityQ.lock);
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	68 04 2f 11 80       	push   $0x80112f04
801045f0:	e8 1b 12 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
801045f5:	83 c4 10             	add    $0x10,%esp
801045f8:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
801045ff:	74 1a                	je     8010461b <fork+0x12b>
		release(&priorityQ.lock);
80104601:	83 ec 0c             	sub    $0xc,%esp
80104604:	68 04 2f 11 80       	push   $0x80112f04
80104609:	e8 a2 11 00 00       	call   801057b0 <release>
		return 0;
8010460e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104611:	e8 ea f2 ff ff       	call   80103900 <insertIntoPQ.part.0>
80104616:	83 c4 10             	add    $0x10,%esp
80104619:	eb ac                	jmp    801045c7 <fork+0xd7>
		release(&priorityQ.lock);
8010461b:	83 ec 0c             	sub    $0xc,%esp
8010461e:	68 04 2f 11 80       	push   $0x80112f04
80104623:	e8 88 11 00 00       	call   801057b0 <release>
80104628:	83 c4 10             	add    $0x10,%esp
8010462b:	eb 9a                	jmp    801045c7 <fork+0xd7>
    return -1;
8010462d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104632:	eb a3                	jmp    801045d7 <fork+0xe7>
    kfree(np->kstack);
80104634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104637:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010463a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010463f:	ff 77 08             	push   0x8(%edi)
80104642:	e8 79 de ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80104647:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
8010464e:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104651:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104658:	e9 7a ff ff ff       	jmp    801045d7 <fork+0xe7>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <scheduler>:
void scheduler(void){
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	53                   	push   %ebx
80104666:	83 ec 0c             	sub    $0xc,%esp
  defaultParent.pid = -2;
80104669:	c7 05 30 2d 11 80 fe 	movl   $0xfffffffe,0x80112d30
80104670:	ff ff ff 
  struct cpu *c = mycpu();
80104673:	e8 b8 fb ff ff       	call   80104230 <mycpu>
  c->proc = 0;
80104678:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010467f:	00 00 00 
  struct cpu *c = mycpu();
80104682:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104684:	8d 78 04             	lea    0x4(%eax),%edi
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80104690:	fb                   	sti    
    acquire(&ptable.lock);
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	68 40 30 11 80       	push   $0x80113040
80104699:	e8 72 11 00 00       	call   80105810 <acquire>
	acquire(&priorityQ.lock);
8010469e:	c7 04 24 04 2f 11 80 	movl   $0x80112f04,(%esp)
801046a5:	e8 66 11 00 00       	call   80105810 <acquire>
	if(priorityQ.sze == 0){
801046aa:	a1 00 2f 11 80       	mov    0x80112f00,%eax
801046af:	83 c4 10             	add    $0x10,%esp
801046b2:	85 c0                	test   %eax,%eax
801046b4:	0f 85 2e 01 00 00    	jne    801047e8 <scheduler+0x188>
		release(&priorityQ.lock);
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	68 04 2f 11 80       	push   $0x80112f04
801046c2:	e8 e9 10 00 00       	call   801057b0 <release>
	acquire(&priorityQ2.lock);
801046c7:	c7 04 24 c4 2d 11 80 	movl   $0x80112dc4,(%esp)
801046ce:	e8 3d 11 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze == 0){
801046d3:	8b 1d c0 2d 11 80    	mov    0x80112dc0,%ebx
801046d9:	83 c4 10             	add    $0x10,%esp
801046dc:	85 db                	test   %ebx,%ebx
801046de:	74 2a                	je     8010470a <scheduler+0xaa>
		release(&priorityQ2.lock);
801046e0:	83 ec 0c             	sub    $0xc,%esp
801046e3:	68 c4 2d 11 80       	push   $0x80112dc4
801046e8:	e8 c3 10 00 00       	call   801057b0 <release>
801046ed:	83 c4 10             	add    $0x10,%esp
	acquire(&priorityQ2.lock);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	68 c4 2d 11 80       	push   $0x80112dc4
801046f8:	e8 13 11 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze == 0){
801046fd:	8b 0d c0 2d 11 80    	mov    0x80112dc0,%ecx
80104703:	83 c4 10             	add    $0x10,%esp
80104706:	85 c9                	test   %ecx,%ecx
80104708:	75 76                	jne    80104780 <scheduler+0x120>
		release(&priorityQ2.lock);
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 c4 2d 11 80       	push   $0x80112dc4
80104712:	e8 99 10 00 00       	call   801057b0 <release>
80104717:	83 c4 10             	add    $0x10,%esp
  	if((p = extractMin()) == 0){release(&ptable.lock);continue;}
8010471a:	e8 31 f7 ff ff       	call   80103e50 <extractMin>
8010471f:	89 c3                	mov    %eax,%ebx
80104721:	85 c0                	test   %eax,%eax
80104723:	0f 84 a7 00 00 00    	je     801047d0 <scheduler+0x170>
  	if(p->state!=RUNNABLE) 
80104729:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010472d:	0f 85 9d 00 00 00    	jne    801047d0 <scheduler+0x170>
  	switchuvm(p);
80104733:	83 ec 0c             	sub    $0xc,%esp
  	c->proc = p;
80104736:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
  	switchuvm(p);
8010473c:	50                   	push   %eax
8010473d:	e8 1e 37 00 00       	call   80107e60 <switchuvm>
  	(p->numSwitches)++;
80104742:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
  	p->state = RUNNING;
80104749:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
  	swtch(&(c->scheduler), p->context);
80104750:	58                   	pop    %eax
80104751:	5a                   	pop    %edx
80104752:	ff 73 1c             	push   0x1c(%ebx)
80104755:	57                   	push   %edi
80104756:	e8 90 13 00 00       	call   80105aeb <swtch>
  	switchkvm();
8010475b:	e8 f0 36 00 00       	call   80107e50 <switchkvm>
  	c->proc = 0;
80104760:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104767:	00 00 00 
    release(&ptable.lock);
8010476a:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80104771:	e8 3a 10 00 00       	call   801057b0 <release>
80104776:	83 c4 10             	add    $0x10,%esp
80104779:	e9 12 ff ff ff       	jmp    80104690 <scheduler+0x30>
8010477e:	66 90                	xchg   %ax,%ax
		release(&priorityQ2.lock);
80104780:	83 ec 0c             	sub    $0xc,%esp
80104783:	68 c4 2d 11 80       	push   $0x80112dc4
80104788:	e8 23 10 00 00       	call   801057b0 <release>
        if((p = extractMin2()) == 0){release(&ptable.lock);break;}
8010478d:	e8 8e f7 ff ff       	call   80103f20 <extractMin2>
80104792:	83 c4 10             	add    $0x10,%esp
80104795:	89 c3                	mov    %eax,%ebx
80104797:	85 c0                	test   %eax,%eax
80104799:	74 7d                	je     80104818 <scheduler+0x1b8>
	acquire(&priorityQ.lock);
8010479b:	83 ec 0c             	sub    $0xc,%esp
8010479e:	68 04 2f 11 80       	push   $0x80112f04
801047a3:	e8 68 10 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
801047a8:	83 c4 10             	add    $0x10,%esp
801047ab:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
801047b2:	74 4c                	je     80104800 <scheduler+0x1a0>
		release(&priorityQ.lock);
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 04 2f 11 80       	push   $0x80112f04
801047bc:	e8 ef 0f 00 00       	call   801057b0 <release>
		return 0;
801047c1:	89 d8                	mov    %ebx,%eax
801047c3:	e8 38 f1 ff ff       	call   80103900 <insertIntoPQ.part.0>
801047c8:	83 c4 10             	add    $0x10,%esp
801047cb:	e9 20 ff ff ff       	jmp    801046f0 <scheduler+0x90>
  	if((p = extractMin()) == 0){release(&ptable.lock);continue;}
801047d0:	83 ec 0c             	sub    $0xc,%esp
801047d3:	68 40 30 11 80       	push   $0x80113040
801047d8:	e8 d3 0f 00 00       	call   801057b0 <release>
801047dd:	83 c4 10             	add    $0x10,%esp
801047e0:	e9 ab fe ff ff       	jmp    80104690 <scheduler+0x30>
801047e5:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	68 04 2f 11 80       	push   $0x80112f04
801047f0:	e8 bb 0f 00 00       	call   801057b0 <release>
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	e9 1d ff ff ff       	jmp    8010471a <scheduler+0xba>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
		release(&priorityQ.lock);
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	68 04 2f 11 80       	push   $0x80112f04
80104808:	e8 a3 0f 00 00       	call   801057b0 <release>
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	e9 db fe ff ff       	jmp    801046f0 <scheduler+0x90>
80104815:	8d 76 00             	lea    0x0(%esi),%esi
        if((p = extractMin2()) == 0){release(&ptable.lock);break;}
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 40 30 11 80       	push   $0x80113040
80104820:	e8 8b 0f 00 00       	call   801057b0 <release>
80104825:	83 c4 10             	add    $0x10,%esp
80104828:	e9 ed fe ff ff       	jmp    8010471a <scheduler+0xba>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <sched>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
  pushcli();
80104835:	e8 86 0e 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010483a:	e8 f1 f9 ff ff       	call   80104230 <mycpu>
  p = c->proc;
8010483f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104845:	e8 c6 0e 00 00       	call   80105710 <popcli>
  if(!holding(&ptable.lock))
8010484a:	83 ec 0c             	sub    $0xc,%esp
8010484d:	68 40 30 11 80       	push   $0x80113040
80104852:	e8 19 0f 00 00       	call   80105770 <holding>
80104857:	83 c4 10             	add    $0x10,%esp
8010485a:	85 c0                	test   %eax,%eax
8010485c:	74 4f                	je     801048ad <sched+0x7d>
  if(mycpu()->ncli != 1)
8010485e:	e8 cd f9 ff ff       	call   80104230 <mycpu>
80104863:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010486a:	75 68                	jne    801048d4 <sched+0xa4>
  if(p->state == RUNNING)
8010486c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104870:	74 55                	je     801048c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104872:	9c                   	pushf  
80104873:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104874:	f6 c4 02             	test   $0x2,%ah
80104877:	75 41                	jne    801048ba <sched+0x8a>
  intena = mycpu()->intena;
80104879:	e8 b2 f9 ff ff       	call   80104230 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010487e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104881:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104887:	e8 a4 f9 ff ff       	call   80104230 <mycpu>
8010488c:	83 ec 08             	sub    $0x8,%esp
8010488f:	ff 70 04             	push   0x4(%eax)
80104892:	53                   	push   %ebx
80104893:	e8 53 12 00 00       	call   80105aeb <swtch>
  mycpu()->intena = intena;
80104898:	e8 93 f9 ff ff       	call   80104230 <mycpu>
}
8010489d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a9:	5b                   	pop    %ebx
801048aa:	5e                   	pop    %esi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret    
    panic("sched ptable.lock");
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	68 b0 8b 10 80       	push   $0x80108bb0
801048b5:	e8 c6 ba ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	68 dc 8b 10 80       	push   $0x80108bdc
801048c2:	e8 b9 ba ff ff       	call   80100380 <panic>
    panic("sched running");
801048c7:	83 ec 0c             	sub    $0xc,%esp
801048ca:	68 ce 8b 10 80       	push   $0x80108bce
801048cf:	e8 ac ba ff ff       	call   80100380 <panic>
    panic("sched locks");
801048d4:	83 ec 0c             	sub    $0xc,%esp
801048d7:	68 c2 8b 10 80       	push   $0x80108bc2
801048dc:	e8 9f ba ff ff       	call   80100380 <panic>
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <exit>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801048f9:	e8 b2 f9 ff ff       	call   801042b0 <myproc>
  if(curproc == initproc)
801048fe:	39 05 74 53 11 80    	cmp    %eax,0x80115374
80104904:	0f 84 bf 00 00 00    	je     801049c9 <exit+0xd9>
8010490a:	89 c6                	mov    %eax,%esi
8010490c:	8d 58 28             	lea    0x28(%eax),%ebx
8010490f:	8d 78 68             	lea    0x68(%eax),%edi
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104918:	8b 03                	mov    (%ebx),%eax
8010491a:	85 c0                	test   %eax,%eax
8010491c:	74 12                	je     80104930 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010491e:	83 ec 0c             	sub    $0xc,%esp
80104921:	50                   	push   %eax
80104922:	e8 c9 c5 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104927:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010492d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104930:	83 c3 04             	add    $0x4,%ebx
80104933:	39 fb                	cmp    %edi,%ebx
80104935:	75 e1                	jne    80104918 <exit+0x28>
  begin_op();
80104937:	e8 24 e4 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010493c:	83 ec 0c             	sub    $0xc,%esp
8010493f:	ff 76 68             	push   0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104942:	bb 74 30 11 80       	mov    $0x80113074,%ebx
  iput(curproc->cwd);
80104947:	e8 64 cf ff ff       	call   801018b0 <iput>
  end_op();
8010494c:	e8 7f e4 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80104951:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104958:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
8010495f:	e8 ac 0e 00 00       	call   80105810 <acquire>
  wakeup1(curproc->parent);
80104964:	8b 46 14             	mov    0x14(%esi),%eax
80104967:	e8 94 f0 ff ff       	call   80103a00 <wakeup1>
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	eb 15                	jmp    80104986 <exit+0x96>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104978:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010497e:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80104984:	74 2a                	je     801049b0 <exit+0xc0>
    if(p->parent == curproc){
80104986:	39 73 14             	cmp    %esi,0x14(%ebx)
80104989:	75 ed                	jne    80104978 <exit+0x88>
      p->parent = initproc;
8010498b:	a1 74 53 11 80       	mov    0x80115374,%eax
      if(p->state == ZOMBIE)
80104990:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80104994:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80104997:	75 df                	jne    80104978 <exit+0x88>
        wakeup1(initproc);
80104999:	e8 62 f0 ff ff       	call   80103a00 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010499e:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801049a4:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
801049aa:	75 da                	jne    80104986 <exit+0x96>
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
801049b0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801049b7:	e8 74 fe ff ff       	call   80104830 <sched>
  panic("zombie exit");
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	68 fd 8b 10 80       	push   $0x80108bfd
801049c4:	e8 b7 b9 ff ff       	call   80100380 <panic>
    panic("init exiting");
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 f0 8b 10 80       	push   $0x80108bf0
801049d1:	e8 aa b9 ff ff       	call   80100380 <panic>
801049d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dd:	8d 76 00             	lea    0x0(%esi),%esi

801049e0 <wait>:
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
  pushcli();
801049e5:	e8 d6 0c 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801049ea:	e8 41 f8 ff ff       	call   80104230 <mycpu>
  p = c->proc;
801049ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049f5:	e8 16 0d 00 00       	call   80105710 <popcli>
  acquire(&ptable.lock);
801049fa:	83 ec 0c             	sub    $0xc,%esp
801049fd:	68 40 30 11 80       	push   $0x80113040
80104a02:	e8 09 0e 00 00       	call   80105810 <acquire>
80104a07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104a0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a0c:	bb 74 30 11 80       	mov    $0x80113074,%ebx
80104a11:	eb 13                	jmp    80104a26 <wait+0x46>
80104a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a17:	90                   	nop
80104a18:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104a1e:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80104a24:	74 1e                	je     80104a44 <wait+0x64>
      if(p->parent != curproc)
80104a26:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a29:	75 ed                	jne    80104a18 <wait+0x38>
      if(p->state == ZOMBIE){
80104a2b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a2f:	74 5f                	je     80104a90 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a31:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80104a37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3c:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80104a42:	75 e2                	jne    80104a26 <wait+0x46>
    if(!havekids || curproc->killed){
80104a44:	85 c0                	test   %eax,%eax
80104a46:	0f 84 9a 00 00 00    	je     80104ae6 <wait+0x106>
80104a4c:	8b 46 24             	mov    0x24(%esi),%eax
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	0f 85 8f 00 00 00    	jne    80104ae6 <wait+0x106>
  pushcli();
80104a57:	e8 64 0c 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104a5c:	e8 cf f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104a61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a67:	e8 a4 0c 00 00       	call   80105710 <popcli>
  if(p == 0)
80104a6c:	85 db                	test   %ebx,%ebx
80104a6e:	0f 84 89 00 00 00    	je     80104afd <wait+0x11d>
  p->chan = chan;
80104a74:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104a77:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a7e:	e8 ad fd ff ff       	call   80104830 <sched>
  p->chan = 0;
80104a83:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104a8a:	e9 7b ff ff ff       	jmp    80104a0a <wait+0x2a>
80104a8f:	90                   	nop
        kfree(p->kstack);
80104a90:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104a93:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a96:	ff 73 08             	push   0x8(%ebx)
80104a99:	e8 22 da ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80104a9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104aa5:	5a                   	pop    %edx
80104aa6:	ff 73 04             	push   0x4(%ebx)
80104aa9:	e8 92 37 00 00       	call   80108240 <freevm>
        p->pid = 0;
80104aae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104ab5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104abc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104ac0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104ac7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104ace:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80104ad5:	e8 d6 0c 00 00       	call   801057b0 <release>
        return pid;
80104ada:	83 c4 10             	add    $0x10,%esp
}
80104add:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae0:	89 f0                	mov    %esi,%eax
80104ae2:	5b                   	pop    %ebx
80104ae3:	5e                   	pop    %esi
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
      release(&ptable.lock);
80104ae6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ae9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104aee:	68 40 30 11 80       	push   $0x80113040
80104af3:	e8 b8 0c 00 00       	call   801057b0 <release>
      return -1;
80104af8:	83 c4 10             	add    $0x10,%esp
80104afb:	eb e0                	jmp    80104add <wait+0xfd>
    panic("sleep");
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	68 09 8c 10 80       	push   $0x80108c09
80104b05:	e8 76 b8 ff ff       	call   80100380 <panic>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <yield>:
void yield(void){
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	68 40 30 11 80       	push   $0x80113040
80104b1d:	e8 ee 0c 00 00       	call   80105810 <acquire>
  pushcli();
80104b22:	e8 99 0b 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104b27:	e8 04 f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104b2c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b32:	e8 d9 0b 00 00       	call   80105710 <popcli>
  short check = (myproc()->state != RUNNABLE);
80104b37:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  pushcli();
80104b3a:	e8 81 0b 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104b3f:	e8 ec f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104b44:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b4a:	e8 c1 0b 00 00       	call   80105710 <popcli>
  if(check)
80104b4f:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104b52:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  if(check)
80104b59:	83 fb 03             	cmp    $0x3,%ebx
80104b5c:	75 22                	jne    80104b80 <yield+0x70>
  sched();
80104b5e:	e8 cd fc ff ff       	call   80104830 <sched>
  release(&ptable.lock);
80104b63:	83 ec 0c             	sub    $0xc,%esp
80104b66:	68 40 30 11 80       	push   $0x80113040
80104b6b:	e8 40 0c 00 00       	call   801057b0 <release>
}
80104b70:	83 c4 10             	add    $0x10,%esp
80104b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b76:	5b                   	pop    %ebx
80104b77:	5e                   	pop    %esi
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pushcli();
80104b80:	e8 3b 0b 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104b85:	e8 a6 f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104b8a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b90:	e8 7b 0b 00 00       	call   80105710 <popcli>
	acquire(&priorityQ.lock);
80104b95:	83 ec 0c             	sub    $0xc,%esp
80104b98:	68 04 2f 11 80       	push   $0x80112f04
80104b9d:	e8 6e 0c 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80104ba2:	83 c4 10             	add    $0x10,%esp
80104ba5:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80104bac:	74 22                	je     80104bd0 <yield+0xc0>
		release(&priorityQ.lock);
80104bae:	83 ec 0c             	sub    $0xc,%esp
80104bb1:	68 04 2f 11 80       	push   $0x80112f04
80104bb6:	e8 f5 0b 00 00       	call   801057b0 <release>
		return 0;
80104bbb:	89 d8                	mov    %ebx,%eax
80104bbd:	e8 3e ed ff ff       	call   80103900 <insertIntoPQ.part.0>
80104bc2:	83 c4 10             	add    $0x10,%esp
80104bc5:	eb 97                	jmp    80104b5e <yield+0x4e>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax
		release(&priorityQ.lock);
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	68 04 2f 11 80       	push   $0x80112f04
80104bd8:	e8 d3 0b 00 00       	call   801057b0 <release>
80104bdd:	83 c4 10             	add    $0x10,%esp
80104be0:	e9 79 ff ff ff       	jmp    80104b5e <yield+0x4e>
80104be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <new_yield>:
void new_yield(void){
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104bf7:	68 40 30 11 80       	push   $0x80113040
80104bfc:	e8 0f 0c 00 00       	call   80105810 <acquire>
  pushcli();
80104c01:	e8 ba 0a 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104c06:	e8 25 f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104c0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c11:	e8 fa 0a 00 00       	call   80105710 <popcli>
  myproc()->state = RUNNABLE;
80104c16:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80104c1d:	e8 9e 0a 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104c22:	e8 09 f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104c27:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c2d:	e8 de 0a 00 00       	call   80105710 <popcli>
	acquire(&priorityQ2.lock);
80104c32:	c7 04 24 c4 2d 11 80 	movl   $0x80112dc4,(%esp)
80104c39:	e8 d2 0b 00 00       	call   80105810 <acquire>
	if(priorityQ2.sze==NPROC){
80104c3e:	83 c4 10             	add    $0x10,%esp
80104c41:	83 3d c0 2d 11 80 40 	cmpl   $0x40,0x80112dc0
80104c48:	74 36                	je     80104c80 <new_yield+0x90>
		release(&priorityQ2.lock);
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	68 c4 2d 11 80       	push   $0x80112dc4
80104c52:	e8 59 0b 00 00       	call   801057b0 <release>
		return 0;
80104c57:	89 d8                	mov    %ebx,%eax
80104c59:	e8 22 ed ff ff       	call   80103980 <insertIntoPQ2.part.0>
80104c5e:	83 c4 10             	add    $0x10,%esp
  sched();
80104c61:	e8 ca fb ff ff       	call   80104830 <sched>
  release(&ptable.lock);
80104c66:	83 ec 0c             	sub    $0xc,%esp
80104c69:	68 40 30 11 80       	push   $0x80113040
80104c6e:	e8 3d 0b 00 00       	call   801057b0 <release>
}
80104c73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	c9                   	leave  
80104c7a:	c3                   	ret    
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
		release(&priorityQ2.lock);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 c4 2d 11 80       	push   $0x80112dc4
80104c88:	e8 23 0b 00 00       	call   801057b0 <release>
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	eb cf                	jmp    80104c61 <new_yield+0x71>
80104c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <sleep>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
80104ca5:	53                   	push   %ebx
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104cac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104caf:	e8 0c 0a 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104cb4:	e8 77 f5 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104cb9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104cbf:	e8 4c 0a 00 00       	call   80105710 <popcli>
  if(p == 0)
80104cc4:	85 db                	test   %ebx,%ebx
80104cc6:	0f 84 87 00 00 00    	je     80104d53 <sleep+0xb3>
  if(lk == 0)
80104ccc:	85 f6                	test   %esi,%esi
80104cce:	74 76                	je     80104d46 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cd0:	81 fe 40 30 11 80    	cmp    $0x80113040,%esi
80104cd6:	74 50                	je     80104d28 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cd8:	83 ec 0c             	sub    $0xc,%esp
80104cdb:	68 40 30 11 80       	push   $0x80113040
80104ce0:	e8 2b 0b 00 00       	call   80105810 <acquire>
    release(lk);
80104ce5:	89 34 24             	mov    %esi,(%esp)
80104ce8:	e8 c3 0a 00 00       	call   801057b0 <release>
  p->chan = chan;
80104ced:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104cf0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104cf7:	e8 34 fb ff ff       	call   80104830 <sched>
  p->chan = 0;
80104cfc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104d03:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80104d0a:	e8 a1 0a 00 00       	call   801057b0 <release>
    acquire(lk);
80104d0f:	89 75 08             	mov    %esi,0x8(%ebp)
80104d12:	83 c4 10             	add    $0x10,%esp
}
80104d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d18:	5b                   	pop    %ebx
80104d19:	5e                   	pop    %esi
80104d1a:	5f                   	pop    %edi
80104d1b:	5d                   	pop    %ebp
    acquire(lk);
80104d1c:	e9 ef 0a 00 00       	jmp    80105810 <acquire>
80104d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104d28:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104d2b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d32:	e8 f9 fa ff ff       	call   80104830 <sched>
  p->chan = 0;
80104d37:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d41:	5b                   	pop    %ebx
80104d42:	5e                   	pop    %esi
80104d43:	5f                   	pop    %edi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
    panic("sleep without lk");
80104d46:	83 ec 0c             	sub    $0xc,%esp
80104d49:	68 0f 8c 10 80       	push   $0x80108c0f
80104d4e:	e8 2d b6 ff ff       	call   80100380 <panic>
    panic("sleep");
80104d53:	83 ec 0c             	sub    $0xc,%esp
80104d56:	68 09 8c 10 80       	push   $0x80108c09
80104d5b:	e8 20 b6 ff ff       	call   80100380 <panic>

80104d60 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 10             	sub    $0x10,%esp
80104d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104d6a:	68 40 30 11 80       	push   $0x80113040
80104d6f:	e8 9c 0a 00 00       	call   80105810 <acquire>
  wakeup1(chan);
80104d74:	89 d8                	mov    %ebx,%eax
80104d76:	e8 85 ec ff ff       	call   80103a00 <wakeup1>
  release(&ptable.lock);
80104d7b:	c7 45 08 40 30 11 80 	movl   $0x80113040,0x8(%ebp)
}
80104d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104d85:	83 c4 10             	add    $0x10,%esp
}
80104d88:	c9                   	leave  
  release(&ptable.lock);
80104d89:	e9 22 0a 00 00       	jmp    801057b0 <release>
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d98:	bb 74 30 11 80       	mov    $0x80113074,%ebx
  acquire(&ptable.lock);
80104d9d:	83 ec 0c             	sub    $0xc,%esp
80104da0:	68 40 30 11 80       	push   $0x80113040
80104da5:	e8 66 0a 00 00       	call   80105810 <acquire>
80104daa:	83 c4 10             	add    $0x10,%esp
80104dad:	eb 0f                	jmp    80104dbe <kill+0x2e>
80104daf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104db6:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80104dbc:	74 32                	je     80104df0 <kill+0x60>
    if(p->pid == pid){
80104dbe:	39 73 10             	cmp    %esi,0x10(%ebx)
80104dc1:	75 ed                	jne    80104db0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104dc3:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
      p->killed = 1;
80104dc7:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      if(p->state == SLEEPING){
80104dce:	74 40                	je     80104e10 <kill+0x80>
        p->state = RUNNABLE;

        if(check)
    	insertIntoPQ(p);
    }
      release(&ptable.lock);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
80104dd3:	68 40 30 11 80       	push   $0x80113040
80104dd8:	e8 d3 09 00 00       	call   801057b0 <release>
      return 0;
80104ddd:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80104de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret    
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	68 40 30 11 80       	push   $0x80113040
80104df8:	e8 b3 09 00 00       	call   801057b0 <release>
  return -1;
80104dfd:	83 c4 10             	add    $0x10,%esp
}
80104e00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80104e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e08:	5b                   	pop    %ebx
80104e09:	5e                   	pop    %esi
80104e0a:	5d                   	pop    %ebp
80104e0b:	c3                   	ret    
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	acquire(&priorityQ.lock);
80104e10:	83 ec 0c             	sub    $0xc,%esp
        p->state = RUNNABLE;
80104e13:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	acquire(&priorityQ.lock);
80104e1a:	68 04 2f 11 80       	push   $0x80112f04
80104e1f:	e8 ec 09 00 00       	call   80105810 <acquire>
	if(priorityQ.sze==NPROC){
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	83 3d 00 2f 11 80 40 	cmpl   $0x40,0x80112f00
80104e2e:	74 19                	je     80104e49 <kill+0xb9>
		release(&priorityQ.lock);
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	68 04 2f 11 80       	push   $0x80112f04
80104e38:	e8 73 09 00 00       	call   801057b0 <release>
		return 0;
80104e3d:	89 d8                	mov    %ebx,%eax
80104e3f:	e8 bc ea ff ff       	call   80103900 <insertIntoPQ.part.0>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	eb 87                	jmp    80104dd0 <kill+0x40>
		release(&priorityQ.lock);
80104e49:	83 ec 0c             	sub    $0xc,%esp
80104e4c:	68 04 2f 11 80       	push   $0x80112f04
80104e51:	e8 5a 09 00 00       	call   801057b0 <release>
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	e9 72 ff ff ff       	jmp    80104dd0 <kill+0x40>
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104e68:	53                   	push   %ebx
80104e69:	bb e0 30 11 80       	mov    $0x801130e0,%ebx
80104e6e:	83 ec 3c             	sub    $0x3c,%esp
80104e71:	eb 27                	jmp    80104e9a <procdump+0x3a>
80104e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e77:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	68 7f 8f 10 80       	push   $0x80108f7f
80104e80:	e8 1b b8 ff ff       	call   801006a0 <cprintf>
80104e85:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e88:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104e8e:	81 fb e0 53 11 80    	cmp    $0x801153e0,%ebx
80104e94:	0f 84 7e 00 00 00    	je     80104f18 <procdump+0xb8>
    if(p->state == UNUSED)
80104e9a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104e9d:	85 c0                	test   %eax,%eax
80104e9f:	74 e7                	je     80104e88 <procdump+0x28>
      state = "???";
80104ea1:	ba 20 8c 10 80       	mov    $0x80108c20,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ea6:	83 f8 05             	cmp    $0x5,%eax
80104ea9:	77 11                	ja     80104ebc <procdump+0x5c>
80104eab:	8b 14 85 80 8c 10 80 	mov    -0x7fef7380(,%eax,4),%edx
      state = "???";
80104eb2:	b8 20 8c 10 80       	mov    $0x80108c20,%eax
80104eb7:	85 d2                	test   %edx,%edx
80104eb9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104ebc:	53                   	push   %ebx
80104ebd:	52                   	push   %edx
80104ebe:	ff 73 a4             	push   -0x5c(%ebx)
80104ec1:	68 24 8c 10 80       	push   $0x80108c24
80104ec6:	e8 d5 b7 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104ecb:	83 c4 10             	add    $0x10,%esp
80104ece:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104ed2:	75 a4                	jne    80104e78 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ed4:	83 ec 08             	sub    $0x8,%esp
80104ed7:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104eda:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104edd:	50                   	push   %eax
80104ede:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104ee1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ee4:	83 c0 08             	add    $0x8,%eax
80104ee7:	50                   	push   %eax
80104ee8:	e8 73 07 00 00       	call   80105660 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	8b 17                	mov    (%edi),%edx
80104ef2:	85 d2                	test   %edx,%edx
80104ef4:	74 82                	je     80104e78 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104ef6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ef9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104efc:	52                   	push   %edx
80104efd:	68 61 86 10 80       	push   $0x80108661
80104f02:	e8 99 b7 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f07:	83 c4 10             	add    $0x10,%esp
80104f0a:	39 fe                	cmp    %edi,%esi
80104f0c:	75 e2                	jne    80104ef0 <procdump+0x90>
80104f0e:	e9 65 ff ff ff       	jmp    80104e78 <procdump+0x18>
80104f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f17:	90                   	nop
  }
}
80104f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f1b:	5b                   	pop    %ebx
80104f1c:	5e                   	pop    %esi
80104f1d:	5f                   	pop    %edi
80104f1e:	5d                   	pop    %ebp
80104f1f:	c3                   	ret    

80104f20 <thread_create>:

int thread_create(void (*fcn)(void *),void *arg,void* stack){
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	83 ec 1c             	sub    $0x1c,%esp
  if((uint)stack==0)
80104f29:	8b 45 10             	mov    0x10(%ebp),%eax
80104f2c:	85 c0                	test   %eax,%eax
80104f2e:	0f 84 11 01 00 00    	je     80105045 <thread_create+0x125>
  pushcli();
80104f34:	e8 87 07 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104f39:	e8 f2 f2 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104f3e:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104f44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80104f47:	e8 c4 07 00 00       	call   80105710 <popcli>
  }
  int i,pid; 
  struct proc *np;  //Create this pointer to alloacate to the new process created by the thread_create() system call
  struct proc *curproc = myproc();  //Gets referemce to the Current process in which thread is being created

  if((np=allocproc())==0)return -1; //If the process could not be created return -1  
80104f4c:	e8 5f e8 ff ff       	call   801037b0 <allocproc>
80104f51:	89 c3                	mov    %eax,%ebx
80104f53:	85 c0                	test   %eax,%eax
80104f55:	0f 84 ea 00 00 00    	je     80105045 <thread_create+0x125>


  //The page directory,size,parent process and memory allocated to this process is same as the current process
  np->pgdir = curproc->pgdir;
80104f5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;   //Equates all variables in the current processs to the new thread...basically this will be the set of all shared variables
80104f5e:	8b 7b 18             	mov    0x18(%ebx),%edi
80104f61:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->pgdir = curproc->pgdir;
80104f66:	8b 42 04             	mov    0x4(%edx),%eax
80104f69:	89 43 04             	mov    %eax,0x4(%ebx)
  np->sz = curproc->sz;
80104f6c:	8b 02                	mov    (%edx),%eax
  np->parent = curproc;
80104f6e:	89 53 14             	mov    %edx,0x14(%ebx)
  np->sz = curproc->sz;
80104f71:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;   //Equates all variables in the current processs to the new thread...basically this will be the set of all shared variables
80104f73:	8b 72 18             	mov    0x18(%edx),%esi
80104f76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  np->isThread = 1;   //Is this process a thread?...Used in thread join later
80104f78:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)

  np->tf->eax = 0;

  np->tf->eip = (int)fcn;   //Sets the instruction pointer to the beginning of the reference to the function call reference (fcn)
80104f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx


  /*Since the files of a process and its threaded process is same..so we check all files to see if it is opened in the parent process
  If yes then we also open them in the threaded process. This is done using the below for loop*/

  for(i=0;i<NOFILE;++i)   //NOFILE denotes the total number of files opened in the kernel
80104f82:	31 f6                	xor    %esi,%esi
80104f84:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104f86:	8b 43 18             	mov    0x18(%ebx),%eax
80104f89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  np->tf->eip = (int)fcn;   //Sets the instruction pointer to the beginning of the reference to the function call reference (fcn)
80104f90:	8b 43 18             	mov    0x18(%ebx),%eax
80104f93:	89 48 38             	mov    %ecx,0x38(%eax)
  np->tf->esp = (int) stack + 4096;   //Allocates 4096 bytes of stack memory to the thread
80104f96:	8b 45 10             	mov    0x10(%ebp),%eax
80104f99:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104f9c:	05 00 10 00 00       	add    $0x1000,%eax
80104fa1:	89 41 44             	mov    %eax,0x44(%ecx)
  np->tf->esp -= 4;  //Decrement stack pointer to store the local variable arg
80104fa4:	8b 43 18             	mov    0x18(%ebx),%eax
  *((int*)(np->tf->esp)) = (int) arg;  //Store the local variable arg
80104fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  np->tf->esp -= 4;  //Decrement stack pointer to store the local variable arg
80104faa:	83 68 44 04          	subl   $0x4,0x44(%eax)
  *((int*)(np->tf->esp)) = (int) arg;  //Store the local variable arg
80104fae:	8b 43 18             	mov    0x18(%ebx),%eax
80104fb1:	8b 40 44             	mov    0x44(%eax),%eax
80104fb4:	89 08                	mov    %ecx,(%eax)
  np->tf->esp-=4;  //Decrement the stack pointer to store the initial Program Counter value
80104fb6:	8b 43 18             	mov    0x18(%ebx),%eax
80104fb9:	83 68 44 04          	subl   $0x4,0x44(%eax)
  *((int*)(np->tf->esp)) = 0xffffffff;  //Store the initial program counter value
80104fbd:	8b 43 18             	mov    0x18(%ebx),%eax
80104fc0:	8b 40 44             	mov    0x44(%eax),%eax
80104fc3:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  for(i=0;i<NOFILE;++i)   //NOFILE denotes the total number of files opened in the kernel
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
  	if(curproc->ofile[i])   //If the file is opened in the parent process
80104fd0:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	74 10                	je     80104fe8 <thread_create+0xc8>
	{
		np->ofile[i] = filedup(curproc->ofile[i]);   //open it in the newly created threaded process
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	50                   	push   %eax
80104fdc:	e8 bf be ff ff       	call   80100ea0 <filedup>
80104fe1:	83 c4 10             	add    $0x10,%esp
80104fe4:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i=0;i<NOFILE;++i)   //NOFILE denotes the total number of files opened in the kernel
80104fe8:	83 c6 01             	add    $0x1,%esi
80104feb:	83 fe 10             	cmp    $0x10,%esi
80104fee:	75 e0                	jne    80104fd0 <thread_create+0xb0>
	}	
  }	
	np->cwd = idup(curproc->cwd);  //Equates directory of parent and threaded process as they are same
80104ff0:	83 ec 0c             	sub    $0xc,%esp
80104ff3:	ff 77 68             	push   0x68(%edi)
80104ff6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104ff9:	e8 52 c7 ff ff       	call   80101750 <idup>
	safestrcpy(np->name,curproc->name,sizeof(curproc->name));
80104ffe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105001:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);  //Equates directory of parent and threaded process as they are same
80105004:	89 43 68             	mov    %eax,0x68(%ebx)
	safestrcpy(np->name,curproc->name,sizeof(curproc->name));
80105007:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010500a:	83 c2 6c             	add    $0x6c,%edx
8010500d:	6a 10                	push   $0x10
8010500f:	52                   	push   %edx
80105010:	50                   	push   %eax
80105011:	e8 7a 0a 00 00       	call   80105a90 <safestrcpy>
	pid = np->pid;  //We will return the value in the end...basically it is the id os the newly created thread
80105016:	8b 73 10             	mov    0x10(%ebx),%esi
	acquire(&ptable.lock);
80105019:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80105020:	e8 eb 07 00 00       	call   80105810 <acquire>
	np->state = RUNNABLE;
80105025:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	release(&ptable.lock);
8010502c:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80105033:	e8 78 07 00 00       	call   801057b0 <release>
	return pid;	
80105038:	83 c4 10             	add    $0x10,%esp
}
8010503b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503e:	89 f0                	mov    %esi,%eax
80105040:	5b                   	pop    %ebx
80105041:	5e                   	pop    %esi
80105042:	5f                   	pop    %edi
80105043:	5d                   	pop    %ebp
80105044:	c3                   	ret    
    return -1;
80105045:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010504a:	eb ef                	jmp    8010503b <thread_create+0x11b>
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105050 <thread_join>:

int thread_join(void){
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  pushcli();
80105055:	e8 66 06 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010505a:	e8 d1 f1 ff ff       	call   80104230 <mycpu>
  p = c->proc;
8010505f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105065:	e8 a6 06 00 00       	call   80105710 <popcli>
	struct proc *p; //Process pointer for looping over all the proccesses
	int havekids, pid;  //havekids denotes whether there are any child processes for the current process
	struct proc *curproc = myproc();  //Pointer to the current process

	acquire(&ptable.lock);  //Acquire a lock and choose a process to kill in the below while loops
8010506a:	83 ec 0c             	sub    $0xc,%esp
8010506d:	68 40 30 11 80       	push   $0x80113040
80105072:	e8 99 07 00 00       	call   80105810 <acquire>
80105077:	83 c4 10             	add    $0x10,%esp
	while(1){
		havekids = 0;
8010507a:	31 d2                	xor    %edx,%edx
    //Continue looping through all process until you find a process which is a child of the current process and a thread we created
		for(p = ptable.proc;p< &ptable.proc[NPROC];++p){
8010507c:	b8 74 30 11 80       	mov    $0x80113074,%eax
80105081:	eb 11                	jmp    80105094 <thread_join+0x44>
80105083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105087:	90                   	nop
80105088:	05 8c 00 00 00       	add    $0x8c,%eax
8010508d:	3d 74 53 11 80       	cmp    $0x80115374,%eax
80105092:	74 23                	je     801050b7 <thread_join+0x67>
			if(p->isThread==0||p->parent!=curproc)
80105094:	8b 48 7c             	mov    0x7c(%eax),%ecx
80105097:	85 c9                	test   %ecx,%ecx
80105099:	74 ed                	je     80105088 <thread_join+0x38>
8010509b:	39 58 14             	cmp    %ebx,0x14(%eax)
8010509e:	75 e8                	jne    80105088 <thread_join+0x38>
			{
				continue;
			}	
			havekids = 1; /*We found a thread to kill now we execute that by setting the state to zombie and then set
      other attributes to NULL/0  */
			if(p->state==ZOMBIE){
801050a0:	83 78 0c 05          	cmpl   $0x5,0xc(%eax)
801050a4:	74 5a                	je     80105100 <thread_join+0xb0>
		for(p = ptable.proc;p< &ptable.proc[NPROC];++p){
801050a6:	05 8c 00 00 00       	add    $0x8c,%eax
			havekids = 1; /*We found a thread to kill now we execute that by setting the state to zombie and then set
801050ab:	ba 01 00 00 00       	mov    $0x1,%edx
		for(p = ptable.proc;p< &ptable.proc[NPROC];++p){
801050b0:	3d 74 53 11 80       	cmp    $0x80115374,%eax
801050b5:	75 dd                	jne    80105094 <thread_join+0x44>
				release(&ptable.lock);
				return pid; //We return the process id of the terminated thread
			}
		}
    //If the current process terminates or the process does not have any kids we return -1 and release the aquired lock
		if(!havekids||curproc->killed){
801050b7:	85 d2                	test   %edx,%edx
801050b9:	0f 84 84 00 00 00    	je     80105143 <thread_join+0xf3>
801050bf:	8b 43 24             	mov    0x24(%ebx),%eax
801050c2:	85 c0                	test   %eax,%eax
801050c4:	75 7d                	jne    80105143 <thread_join+0xf3>
  pushcli();
801050c6:	e8 f5 05 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801050cb:	e8 60 f1 ff ff       	call   80104230 <mycpu>
  p = c->proc;
801050d0:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801050d6:	e8 35 06 00 00       	call   80105710 <popcli>
  if(p == 0)
801050db:	85 f6                	test   %esi,%esi
801050dd:	74 7b                	je     8010515a <thread_join+0x10a>
  p->chan = chan;
801050df:	89 5e 20             	mov    %ebx,0x20(%esi)
  p->state = SLEEPING;
801050e2:	c7 46 0c 02 00 00 00 	movl   $0x2,0xc(%esi)
  sched();
801050e9:	e8 42 f7 ff ff       	call   80104830 <sched>
  p->chan = 0;
801050ee:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
}
801050f5:	eb 83                	jmp    8010507a <thread_join+0x2a>
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax
				release(&ptable.lock);
80105100:	83 ec 0c             	sub    $0xc,%esp
				pid = p->pid;
80105103:	8b 58 10             	mov    0x10(%eax),%ebx
				p->name[0] = 0;
80105106:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->kstack = 0;
8010510a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				p->pid = 0;
80105111:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
80105118:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->killed = 0;
8010511f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
				p->state = UNUSED;
80105126:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				release(&ptable.lock);
8010512d:	68 40 30 11 80       	push   $0x80113040
80105132:	e8 79 06 00 00       	call   801057b0 <release>
				return pid; //We return the process id of the terminated thread
80105137:	83 c4 10             	add    $0x10,%esp
			return -1;
		}
		sleep(curproc,&ptable.lock);
	}

}
8010513a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010513d:	89 d8                	mov    %ebx,%eax
8010513f:	5b                   	pop    %ebx
80105140:	5e                   	pop    %esi
80105141:	5d                   	pop    %ebp
80105142:	c3                   	ret    
			release(&ptable.lock);
80105143:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80105146:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
			release(&ptable.lock);
8010514b:	68 40 30 11 80       	push   $0x80113040
80105150:	e8 5b 06 00 00       	call   801057b0 <release>
			return -1;
80105155:	83 c4 10             	add    $0x10,%esp
80105158:	eb e0                	jmp    8010513a <thread_join+0xea>
    panic("sleep");
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	68 09 8c 10 80       	push   $0x80108c09
80105162:	e8 19 b2 ff ff       	call   80100380 <panic>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <thread_exit>:


int thread_exit(){
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
80105176:	83 ec 0c             	sub    $0xc,%esp
	struct proc *curproc = myproc();  //reference to the process which we have to kill
80105179:	e8 32 f1 ff ff       	call   801042b0 <myproc>
	struct proc *p;     //Used in looping through the processes 
	int fd; 

	if(curproc==initproc)
8010517e:	39 05 74 53 11 80    	cmp    %eax,0x80115374
80105184:	0f 84 bf 00 00 00    	je     80105249 <thread_exit+0xd9>
8010518a:	89 c6                	mov    %eax,%esi
8010518c:	8d 58 28             	lea    0x28(%eax),%ebx
8010518f:	8d 78 68             	lea    0x68(%eax),%edi
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		panic("init exiting");  
	}

  //Check all the files opened by the current process and close them one by one by setting the reference to NULL
	for(fd = 0;fd<NOFILE;fd++){
		if(curproc->ofile[fd]){
80105198:	8b 03                	mov    (%ebx),%eax
8010519a:	85 c0                	test   %eax,%eax
8010519c:	74 12                	je     801051b0 <thread_exit+0x40>
			fileclose(curproc->ofile[fd]);
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	50                   	push   %eax
801051a2:	e8 49 bd ff ff       	call   80100ef0 <fileclose>
			curproc->ofile[fd] = 0;
801051a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801051ad:	83 c4 10             	add    $0x10,%esp
	for(fd = 0;fd<NOFILE;fd++){
801051b0:	83 c3 04             	add    $0x4,%ebx
801051b3:	39 fb                	cmp    %edi,%ebx
801051b5:	75 e1                	jne    80105198 <thread_exit+0x28>
		}
	}
	begin_op();
801051b7:	e8 a4 db ff ff       	call   80102d60 <begin_op>
	iput(curproc->cwd);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	ff 76 68             	push   0x68(%esi)
	curproc->cwd = 0;
	acquire(&ptable.lock);

	wakeup1(curproc->parent);
	
	for(p=ptable.proc;p<&ptable.proc[NPROC];++p){
801051c2:	bb 74 30 11 80       	mov    $0x80113074,%ebx
	iput(curproc->cwd);
801051c7:	e8 e4 c6 ff ff       	call   801018b0 <iput>
	end_op();
801051cc:	e8 ff db ff ff       	call   80102dd0 <end_op>
	curproc->cwd = 0;
801051d1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
	acquire(&ptable.lock);
801051d8:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
801051df:	e8 2c 06 00 00       	call   80105810 <acquire>
	wakeup1(curproc->parent);
801051e4:	8b 46 14             	mov    0x14(%esi),%eax
801051e7:	e8 14 e8 ff ff       	call   80103a00 <wakeup1>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	eb 15                	jmp    80105206 <thread_exit+0x96>
801051f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for(p=ptable.proc;p<&ptable.proc[NPROC];++p){
801051f8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801051fe:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
80105204:	74 2a                	je     80105230 <thread_exit+0xc0>
		if(p->parent==curproc){
80105206:	39 73 14             	cmp    %esi,0x14(%ebx)
80105209:	75 ed                	jne    801051f8 <thread_exit+0x88>
			p->parent = initproc;
8010520b:	a1 74 53 11 80       	mov    0x80115374,%eax
			if(p->state==ZOMBIE){
80105210:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
			p->parent = initproc;
80105214:	89 43 14             	mov    %eax,0x14(%ebx)
			if(p->state==ZOMBIE){
80105217:	75 df                	jne    801051f8 <thread_exit+0x88>
				wakeup1(initproc);
80105219:	e8 e2 e7 ff ff       	call   80103a00 <wakeup1>
	for(p=ptable.proc;p<&ptable.proc[NPROC];++p){
8010521e:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105224:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
8010522a:	75 da                	jne    80105206 <thread_exit+0x96>
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			}
		}
	}
	curproc->state = ZOMBIE;
80105230:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
	sched();
80105237:	e8 f4 f5 ff ff       	call   80104830 <sched>
	panic("zombie exit");
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	68 fd 8b 10 80       	push   $0x80108bfd
80105244:	e8 37 b1 ff ff       	call   80100380 <panic>
		panic("init exiting");  
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 f0 8b 10 80       	push   $0x80108bf0
80105251:	e8 2a b1 ff ff       	call   80100380 <panic>
80105256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525d:	8d 76 00             	lea    0x0(%esi),%esi

80105260 <getNumProc>:
}

int getNumProc(void){
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	53                   	push   %ebx
  int ans = 0;
80105264:	31 db                	xor    %ebx,%ebx
int getNumProc(void){
80105266:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
80105269:	68 40 30 11 80       	push   $0x80113040
8010526e:	e8 9d 05 00 00       	call   80105810 <acquire>
80105273:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc;p<&ptable.proc[NPROC];++p){
80105276:	b8 74 30 11 80       	mov    $0x80113074,%eax
8010527b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop
    if(p->state!=UNUSED)
      ++ans;
80105280:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
80105284:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p=ptable.proc;p<&ptable.proc[NPROC];++p){
80105287:	05 8c 00 00 00       	add    $0x8c,%eax
8010528c:	3d 74 53 11 80       	cmp    $0x80115374,%eax
80105291:	75 ed                	jne    80105280 <getNumProc+0x20>
  }
  release(&ptable.lock);
80105293:	83 ec 0c             	sub    $0xc,%esp
80105296:	68 40 30 11 80       	push   $0x80113040
8010529b:	e8 10 05 00 00       	call   801057b0 <release>
  return ans;
}
801052a0:	89 d8                	mov    %ebx,%eax
801052a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <getMaxPid>:

int getMaxPid(void){
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	53                   	push   %ebx
  int ans = -1;
801052b4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
int getMaxPid(void){
801052b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
801052bc:	68 40 30 11 80       	push   $0x80113040
801052c1:	e8 4a 05 00 00       	call   80105810 <acquire>
801052c6:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc;p<&ptable.proc[NPROC];++p)
801052c9:	b8 74 30 11 80       	mov    $0x80113074,%eax
801052ce:	66 90                	xchg   %ax,%ax
    if(p->pid>ans)
801052d0:	8b 50 10             	mov    0x10(%eax),%edx
801052d3:	39 d3                	cmp    %edx,%ebx
801052d5:	0f 4c da             	cmovl  %edx,%ebx
  for(p = ptable.proc;p<&ptable.proc[NPROC];++p)
801052d8:	05 8c 00 00 00       	add    $0x8c,%eax
801052dd:	3d 74 53 11 80       	cmp    $0x80115374,%eax
801052e2:	75 ec                	jne    801052d0 <getMaxPid+0x20>
      ans = p->pid;
  release(&ptable.lock);
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	68 40 30 11 80       	push   $0x80113040
801052ec:	e8 bf 04 00 00       	call   801057b0 <release>
  return ans;  
}
801052f1:	89 d8                	mov    %ebx,%eax
801052f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052f6:	c9                   	leave  
801052f7:	c3                   	ret    
801052f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop

80105300 <set_burst_timeAssist>:

int set_burst_timeAssist(int burst_time){
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	56                   	push   %esi
80105304:	53                   	push   %ebx
80105305:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105308:	e8 b3 03 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010530d:	e8 1e ef ff ff       	call   80104230 <mycpu>
  p = c->proc;
80105312:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105318:	e8 f3 03 00 00       	call   80105710 <popcli>
	struct proc *p = myproc();
	p->burst_time = burst_time;
8010531d:	89 9e 84 00 00 00    	mov    %ebx,0x84(%esi)
	if(burst_time < quant){
80105323:	39 1d 08 b0 10 80    	cmp    %ebx,0x8010b008
80105329:	7e 06                	jle    80105331 <set_burst_timeAssist+0x31>
		quant = burst_time;
8010532b:	89 1d 08 b0 10 80    	mov    %ebx,0x8010b008
	}
        yield();
80105331:	e8 da f7 ff ff       	call   80104b10 <yield>

	return 0;
}
80105336:	5b                   	pop    %ebx
80105337:	31 c0                	xor    %eax,%eax
80105339:	5e                   	pop    %esi
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105340 <get_burst_timeAssist>:

int get_burst_timeAssist(){
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80105347:	e8 74 03 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010534c:	e8 df ee ff ff       	call   80104230 <mycpu>
  p = c->proc;
80105351:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105357:	e8 b4 03 00 00       	call   80105710 <popcli>
	struct proc *p = myproc();

	return p->burst_time;
8010535c:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax

}
80105362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105365:	c9                   	leave  
80105366:	c3                   	ret    
80105367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536e:	66 90                	xchg   %ax,%ax

80105370 <getProcInfoHelp>:

struct processInfo getProcInfoHelp(int pid){
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
80105376:	83 ec 28             	sub    $0x28,%esp
80105379:	8b 75 08             	mov    0x8(%ebp),%esi
8010537c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct proc *p;
  struct processInfo temp = {-1,0,0};
  acquire(&ptable.lock);
8010537f:	68 40 30 11 80       	push   $0x80113040
80105384:	e8 87 04 00 00       	call   80105810 <acquire>
80105389:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc;p<&ptable.proc[NPROC];++p)
8010538c:	b8 74 30 11 80       	mov    $0x80113074,%eax
80105391:	eb 11                	jmp    801053a4 <getProcInfoHelp+0x34>
80105393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105397:	90                   	nop
80105398:	05 8c 00 00 00       	add    $0x8c,%eax
8010539d:	3d 74 53 11 80       	cmp    $0x80115374,%eax
801053a2:	74 4c                	je     801053f0 <getProcInfoHelp+0x80>
  {
    if(p->state!=UNUSED)
801053a4:	8b 50 0c             	mov    0xc(%eax),%edx
801053a7:	85 d2                	test   %edx,%edx
801053a9:	74 ed                	je     80105398 <getProcInfoHelp+0x28>
    {
      if(p->pid==pid){
801053ab:	39 58 10             	cmp    %ebx,0x10(%eax)
801053ae:	75 e8                	jne    80105398 <getProcInfoHelp+0x28>
        temp.ppid = p->parent->pid;
801053b0:	8b 50 14             	mov    0x14(%eax),%edx
        temp.psize = p->sz;
        temp.numberContextSwitches = p->numSwitches;
        release(&ptable.lock);
801053b3:	83 ec 0c             	sub    $0xc,%esp
        temp.psize = p->sz;
801053b6:	8b 38                	mov    (%eax),%edi
        temp.numberContextSwitches = p->numSwitches;
801053b8:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
        temp.ppid = p->parent->pid;
801053be:	8b 52 10             	mov    0x10(%edx),%edx
        release(&ptable.lock);
801053c1:	68 40 30 11 80       	push   $0x80113040
        temp.ppid = p->parent->pid;
801053c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        release(&ptable.lock);
801053c9:	e8 e2 03 00 00       	call   801057b0 <release>
        return temp;
801053ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	89 16                	mov    %edx,(%esi)
      }
    } 
  }    
      release(&ptable.lock);
      return temp;
}
801053d6:	89 f0                	mov    %esi,%eax
        return temp;
801053d8:	89 7e 04             	mov    %edi,0x4(%esi)
801053db:	89 5e 08             	mov    %ebx,0x8(%esi)
}
801053de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e1:	5b                   	pop    %ebx
801053e2:	5e                   	pop    %esi
801053e3:	5f                   	pop    %edi
801053e4:	5d                   	pop    %ebp
801053e5:	c2 04 00             	ret    $0x4
801053e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
      release(&ptable.lock);
801053f0:	83 ec 0c             	sub    $0xc,%esp
      return temp;
801053f3:	31 ff                	xor    %edi,%edi
801053f5:	31 db                	xor    %ebx,%ebx
      release(&ptable.lock);
801053f7:	68 40 30 11 80       	push   $0x80113040
801053fc:	e8 af 03 00 00       	call   801057b0 <release>
      return temp;
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105409:	eb c9                	jmp    801053d4 <getProcInfoHelp+0x64>
8010540b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop

80105410 <getCurrentInfoAssist>:

struct processInfo getCurrentInfoAssist(){
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx

  struct proc *p;
  struct processInfo temp = {-1,0,0};

  acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105416:	bb 74 30 11 80       	mov    $0x80113074,%ebx
struct processInfo getCurrentInfoAssist(){
8010541b:	83 ec 28             	sub    $0x28,%esp
8010541e:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
80105421:	68 40 30 11 80       	push   $0x80113040
80105426:	e8 e5 03 00 00       	call   80105810 <acquire>
8010542b:	83 c4 10             	add    $0x10,%esp
8010542e:	eb 0e                	jmp    8010543e <getCurrentInfoAssist+0x2e>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105430:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105436:	81 fb 74 53 11 80    	cmp    $0x80115374,%ebx
8010543c:	74 62                	je     801054a0 <getCurrentInfoAssist+0x90>
      if(p->state != UNUSED){
8010543e:	8b 43 0c             	mov    0xc(%ebx),%eax
80105441:	85 c0                	test   %eax,%eax
80105443:	74 eb                	je     80105430 <getCurrentInfoAssist+0x20>
  pushcli();
80105445:	e8 76 02 00 00       	call   801056c0 <pushcli>
  c = mycpu();
8010544a:	e8 e1 ed ff ff       	call   80104230 <mycpu>
  p = c->proc;
8010544f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105455:	e8 b6 02 00 00       	call   80105710 <popcli>
        // printf(1, "%d\n", p->pid);
        if(p == myproc()) {
8010545a:	39 de                	cmp    %ebx,%esi
8010545c:	75 d2                	jne    80105430 <getCurrentInfoAssist+0x20>
          temp.ppid = p->parent->pid;
8010545e:	8b 43 14             	mov    0x14(%ebx),%eax
          temp.psize = p->sz;
          temp.numberContextSwitches = p->numSwitches;
          release(&ptable.lock);
80105461:	83 ec 0c             	sub    $0xc,%esp
          temp.psize = p->sz;
80105464:	8b 33                	mov    (%ebx),%esi
          temp.numberContextSwitches = p->numSwitches;
80105466:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
          temp.ppid = p->parent->pid;
8010546c:	8b 40 10             	mov    0x10(%eax),%eax
          release(&ptable.lock);
8010546f:	68 40 30 11 80       	push   $0x80113040
          temp.ppid = p->parent->pid;
80105474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          release(&ptable.lock);
80105477:	e8 34 03 00 00       	call   801057b0 <release>
          return temp;
8010547c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	89 07                	mov    %eax,(%edi)
    }
    release(&ptable.lock);

    return temp;

}
80105484:	89 f8                	mov    %edi,%eax
          return temp;
80105486:	89 77 04             	mov    %esi,0x4(%edi)
80105489:	89 5f 08             	mov    %ebx,0x8(%edi)
}
8010548c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010548f:	5b                   	pop    %ebx
80105490:	5e                   	pop    %esi
80105491:	5f                   	pop    %edi
80105492:	5d                   	pop    %ebp
80105493:	c2 04 00             	ret    $0x4
80105496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
801054a0:	83 ec 0c             	sub    $0xc,%esp
    return temp;
801054a3:	31 f6                	xor    %esi,%esi
801054a5:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
801054a7:	68 40 30 11 80       	push   $0x80113040
801054ac:	e8 ff 02 00 00       	call   801057b0 <release>
    return temp;
801054b1:	83 c4 10             	add    $0x10,%esp
801054b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b9:	eb c7                	jmp    80105482 <getCurrentInfoAssist+0x72>
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop

801054c0 <getCurrentPIDAssist>:

int getCurrentPIDAssist(void){
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	53                   	push   %ebx
801054c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801054c7:	e8 f4 01 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801054cc:	e8 5f ed ff ff       	call   80104230 <mycpu>
  p = c->proc;
801054d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801054d7:	e8 34 02 00 00       	call   80105710 <popcli>
  if(!myproc())return -1;
801054dc:	85 db                	test   %ebx,%ebx
801054de:	74 1d                	je     801054fd <getCurrentPIDAssist+0x3d>
  pushcli();
801054e0:	e8 db 01 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801054e5:	e8 46 ed ff ff       	call   80104230 <mycpu>
  p = c->proc;
801054ea:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801054f0:	e8 1b 02 00 00       	call   80105710 <popcli>
  return myproc()->pid;
801054f5:	8b 43 10             	mov    0x10(%ebx),%eax
}
801054f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054fb:	c9                   	leave  
801054fc:	c3                   	ret    
  if(!myproc())return -1;
801054fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105502:	eb f4                	jmp    801054f8 <getCurrentPIDAssist+0x38>
80105504:	66 90                	xchg   %ax,%ax
80105506:	66 90                	xchg   %ax,%ax
80105508:	66 90                	xchg   %ax,%ax
8010550a:	66 90                	xchg   %ax,%ax
8010550c:	66 90                	xchg   %ax,%ax
8010550e:	66 90                	xchg   %ax,%ax

80105510 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	53                   	push   %ebx
80105514:	83 ec 0c             	sub    $0xc,%esp
80105517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010551a:	68 98 8c 10 80       	push   $0x80108c98
8010551f:	8d 43 04             	lea    0x4(%ebx),%eax
80105522:	50                   	push   %eax
80105523:	e8 18 01 00 00       	call   80105640 <initlock>
  lk->name = name;
80105528:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010552b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105531:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105534:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010553b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010553e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105541:	c9                   	leave  
80105542:	c3                   	ret    
80105543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105550 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
80105555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105558:	8d 73 04             	lea    0x4(%ebx),%esi
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	56                   	push   %esi
8010555f:	e8 ac 02 00 00       	call   80105810 <acquire>
  while (lk->locked) {
80105564:	8b 13                	mov    (%ebx),%edx
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 d2                	test   %edx,%edx
8010556b:	74 16                	je     80105583 <acquiresleep+0x33>
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
80105575:	e8 26 f7 ff ff       	call   80104ca0 <sleep>
  while (lk->locked) {
8010557a:	8b 03                	mov    (%ebx),%eax
8010557c:	83 c4 10             	add    $0x10,%esp
8010557f:	85 c0                	test   %eax,%eax
80105581:	75 ed                	jne    80105570 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105583:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105589:	e8 22 ed ff ff       	call   801042b0 <myproc>
8010558e:	8b 40 10             	mov    0x10(%eax),%eax
80105591:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105594:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105597:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559a:	5b                   	pop    %ebx
8010559b:	5e                   	pop    %esi
8010559c:	5d                   	pop    %ebp
  release(&lk->lk);
8010559d:	e9 0e 02 00 00       	jmp    801057b0 <release>
801055a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801055b8:	8d 73 04             	lea    0x4(%ebx),%esi
801055bb:	83 ec 0c             	sub    $0xc,%esp
801055be:	56                   	push   %esi
801055bf:	e8 4c 02 00 00       	call   80105810 <acquire>
  lk->locked = 0;
801055c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801055ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801055d1:	89 1c 24             	mov    %ebx,(%esp)
801055d4:	e8 87 f7 ff ff       	call   80104d60 <wakeup>
  release(&lk->lk);
801055d9:	89 75 08             	mov    %esi,0x8(%ebp)
801055dc:	83 c4 10             	add    $0x10,%esp
}
801055df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5d                   	pop    %ebp
  release(&lk->lk);
801055e5:	e9 c6 01 00 00       	jmp    801057b0 <release>
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	31 ff                	xor    %edi,%edi
801055f6:	56                   	push   %esi
801055f7:	53                   	push   %ebx
801055f8:	83 ec 18             	sub    $0x18,%esp
801055fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801055fe:	8d 73 04             	lea    0x4(%ebx),%esi
80105601:	56                   	push   %esi
80105602:	e8 09 02 00 00       	call   80105810 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105607:	8b 03                	mov    (%ebx),%eax
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	75 18                	jne    80105628 <holdingsleep+0x38>
  release(&lk->lk);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	56                   	push   %esi
80105614:	e8 97 01 00 00       	call   801057b0 <release>
  return r;
}
80105619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561c:	89 f8                	mov    %edi,%eax
8010561e:	5b                   	pop    %ebx
8010561f:	5e                   	pop    %esi
80105620:	5f                   	pop    %edi
80105621:	5d                   	pop    %ebp
80105622:	c3                   	ret    
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105628:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010562b:	e8 80 ec ff ff       	call   801042b0 <myproc>
80105630:	39 58 10             	cmp    %ebx,0x10(%eax)
80105633:	0f 94 c0             	sete   %al
80105636:	0f b6 c0             	movzbl %al,%eax
80105639:	89 c7                	mov    %eax,%edi
8010563b:	eb d3                	jmp    80105610 <holdingsleep+0x20>
8010563d:	66 90                	xchg   %ax,%ax
8010563f:	90                   	nop

80105640 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105646:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010564f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105659:	5d                   	pop    %ebp
8010565a:	c3                   	ret    
8010565b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop

80105660 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105660:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105661:	31 d2                	xor    %edx,%edx
{
80105663:	89 e5                	mov    %esp,%ebp
80105665:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105666:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010566c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010566f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105670:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105676:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010567c:	77 1a                	ja     80105698 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010567e:	8b 58 04             	mov    0x4(%eax),%ebx
80105681:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105684:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105687:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105689:	83 fa 0a             	cmp    $0xa,%edx
8010568c:	75 e2                	jne    80105670 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010568e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105691:	c9                   	leave  
80105692:	c3                   	ret    
80105693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105697:	90                   	nop
  for(; i < 10; i++)
80105698:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010569b:	8d 51 28             	lea    0x28(%ecx),%edx
8010569e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801056a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056a6:	83 c0 04             	add    $0x4,%eax
801056a9:	39 d0                	cmp    %edx,%eax
801056ab:	75 f3                	jne    801056a0 <getcallerpcs+0x40>
}
801056ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b0:	c9                   	leave  
801056b1:	c3                   	ret    
801056b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	53                   	push   %ebx
801056c4:	83 ec 04             	sub    $0x4,%esp
801056c7:	9c                   	pushf  
801056c8:	5b                   	pop    %ebx
  asm volatile("cli");
801056c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801056ca:	e8 61 eb ff ff       	call   80104230 <mycpu>
801056cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801056d5:	85 c0                	test   %eax,%eax
801056d7:	74 17                	je     801056f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801056d9:	e8 52 eb ff ff       	call   80104230 <mycpu>
801056de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801056e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e8:	c9                   	leave  
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801056f0:	e8 3b eb ff ff       	call   80104230 <mycpu>
801056f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801056fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105701:	eb d6                	jmp    801056d9 <pushcli+0x19>
80105703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <popcli>:

void
popcli(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105716:	9c                   	pushf  
80105717:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105718:	f6 c4 02             	test   $0x2,%ah
8010571b:	75 35                	jne    80105752 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010571d:	e8 0e eb ff ff       	call   80104230 <mycpu>
80105722:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105729:	78 34                	js     8010575f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010572b:	e8 00 eb ff ff       	call   80104230 <mycpu>
80105730:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105736:	85 d2                	test   %edx,%edx
80105738:	74 06                	je     80105740 <popcli+0x30>
    sti();
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105740:	e8 eb ea ff ff       	call   80104230 <mycpu>
80105745:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010574b:	85 c0                	test   %eax,%eax
8010574d:	74 eb                	je     8010573a <popcli+0x2a>
  asm volatile("sti");
8010574f:	fb                   	sti    
}
80105750:	c9                   	leave  
80105751:	c3                   	ret    
    panic("popcli - interruptible");
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	68 a3 8c 10 80       	push   $0x80108ca3
8010575a:	e8 21 ac ff ff       	call   80100380 <panic>
    panic("popcli");
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	68 ba 8c 10 80       	push   $0x80108cba
80105767:	e8 14 ac ff ff       	call   80100380 <panic>
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <holding>:
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	56                   	push   %esi
80105774:	53                   	push   %ebx
80105775:	8b 75 08             	mov    0x8(%ebp),%esi
80105778:	31 db                	xor    %ebx,%ebx
  pushcli();
8010577a:	e8 41 ff ff ff       	call   801056c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010577f:	8b 06                	mov    (%esi),%eax
80105781:	85 c0                	test   %eax,%eax
80105783:	75 0b                	jne    80105790 <holding+0x20>
  popcli();
80105785:	e8 86 ff ff ff       	call   80105710 <popcli>
}
8010578a:	89 d8                	mov    %ebx,%eax
8010578c:	5b                   	pop    %ebx
8010578d:	5e                   	pop    %esi
8010578e:	5d                   	pop    %ebp
8010578f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105790:	8b 5e 08             	mov    0x8(%esi),%ebx
80105793:	e8 98 ea ff ff       	call   80104230 <mycpu>
80105798:	39 c3                	cmp    %eax,%ebx
8010579a:	0f 94 c3             	sete   %bl
  popcli();
8010579d:	e8 6e ff ff ff       	call   80105710 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801057a2:	0f b6 db             	movzbl %bl,%ebx
}
801057a5:	89 d8                	mov    %ebx,%eax
801057a7:	5b                   	pop    %ebx
801057a8:	5e                   	pop    %esi
801057a9:	5d                   	pop    %ebp
801057aa:	c3                   	ret    
801057ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop

801057b0 <release>:
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	56                   	push   %esi
801057b4:	53                   	push   %ebx
801057b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801057b8:	e8 03 ff ff ff       	call   801056c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801057bd:	8b 03                	mov    (%ebx),%eax
801057bf:	85 c0                	test   %eax,%eax
801057c1:	75 15                	jne    801057d8 <release+0x28>
  popcli();
801057c3:	e8 48 ff ff ff       	call   80105710 <popcli>
    panic("release");
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	68 c1 8c 10 80       	push   $0x80108cc1
801057d0:	e8 ab ab ff ff       	call   80100380 <panic>
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801057d8:	8b 73 08             	mov    0x8(%ebx),%esi
801057db:	e8 50 ea ff ff       	call   80104230 <mycpu>
801057e0:	39 c6                	cmp    %eax,%esi
801057e2:	75 df                	jne    801057c3 <release+0x13>
  popcli();
801057e4:	e8 27 ff ff ff       	call   80105710 <popcli>
  lk->pcs[0] = 0;
801057e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801057f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801057f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801057fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105802:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105805:	5b                   	pop    %ebx
80105806:	5e                   	pop    %esi
80105807:	5d                   	pop    %ebp
  popcli();
80105808:	e9 03 ff ff ff       	jmp    80105710 <popcli>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <acquire>:
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
80105814:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105817:	e8 a4 fe ff ff       	call   801056c0 <pushcli>
  if(holding(lk))
8010581c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010581f:	e8 9c fe ff ff       	call   801056c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105824:	8b 03                	mov    (%ebx),%eax
80105826:	85 c0                	test   %eax,%eax
80105828:	75 7e                	jne    801058a8 <acquire+0x98>
  popcli();
8010582a:	e8 e1 fe ff ff       	call   80105710 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010582f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105838:	8b 55 08             	mov    0x8(%ebp),%edx
8010583b:	89 c8                	mov    %ecx,%eax
8010583d:	f0 87 02             	lock xchg %eax,(%edx)
80105840:	85 c0                	test   %eax,%eax
80105842:	75 f4                	jne    80105838 <acquire+0x28>
  __sync_synchronize();
80105844:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105849:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010584c:	e8 df e9 ff ff       	call   80104230 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105851:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105854:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105856:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105859:	31 c0                	xor    %eax,%eax
8010585b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105860:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105866:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010586c:	77 1a                	ja     80105888 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010586e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105871:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105875:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105878:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010587a:	83 f8 0a             	cmp    $0xa,%eax
8010587d:	75 e1                	jne    80105860 <acquire+0x50>
}
8010587f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105882:	c9                   	leave  
80105883:	c3                   	ret    
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105888:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010588c:	8d 51 34             	lea    0x34(%ecx),%edx
8010588f:	90                   	nop
    pcs[i] = 0;
80105890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105896:	83 c0 04             	add    $0x4,%eax
80105899:	39 c2                	cmp    %eax,%edx
8010589b:	75 f3                	jne    80105890 <acquire+0x80>
}
8010589d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a0:	c9                   	leave  
801058a1:	c3                   	ret    
801058a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801058a8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801058ab:	e8 80 e9 ff ff       	call   80104230 <mycpu>
801058b0:	39 c3                	cmp    %eax,%ebx
801058b2:	0f 85 72 ff ff ff    	jne    8010582a <acquire+0x1a>
  popcli();
801058b8:	e8 53 fe ff ff       	call   80105710 <popcli>
    panic("acquire");
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	68 c9 8c 10 80       	push   $0x80108cc9
801058c5:	e8 b6 aa ff ff       	call   80100380 <panic>
801058ca:	66 90                	xchg   %ax,%ax
801058cc:	66 90                	xchg   %ax,%ax
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	8b 55 08             	mov    0x8(%ebp),%edx
801058d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801058da:	53                   	push   %ebx
801058db:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801058de:	89 d7                	mov    %edx,%edi
801058e0:	09 cf                	or     %ecx,%edi
801058e2:	83 e7 03             	and    $0x3,%edi
801058e5:	75 29                	jne    80105910 <memset+0x40>
    c &= 0xFF;
801058e7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801058ea:	c1 e0 18             	shl    $0x18,%eax
801058ed:	89 fb                	mov    %edi,%ebx
801058ef:	c1 e9 02             	shr    $0x2,%ecx
801058f2:	c1 e3 10             	shl    $0x10,%ebx
801058f5:	09 d8                	or     %ebx,%eax
801058f7:	09 f8                	or     %edi,%eax
801058f9:	c1 e7 08             	shl    $0x8,%edi
801058fc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801058fe:	89 d7                	mov    %edx,%edi
80105900:	fc                   	cld    
80105901:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105903:	5b                   	pop    %ebx
80105904:	89 d0                	mov    %edx,%eax
80105906:	5f                   	pop    %edi
80105907:	5d                   	pop    %ebp
80105908:	c3                   	ret    
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105910:	89 d7                	mov    %edx,%edi
80105912:	fc                   	cld    
80105913:	f3 aa                	rep stos %al,%es:(%edi)
80105915:	5b                   	pop    %ebx
80105916:	89 d0                	mov    %edx,%eax
80105918:	5f                   	pop    %edi
80105919:	5d                   	pop    %ebp
8010591a:	c3                   	ret    
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop

80105920 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	56                   	push   %esi
80105924:	8b 75 10             	mov    0x10(%ebp),%esi
80105927:	8b 55 08             	mov    0x8(%ebp),%edx
8010592a:	53                   	push   %ebx
8010592b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010592e:	85 f6                	test   %esi,%esi
80105930:	74 2e                	je     80105960 <memcmp+0x40>
80105932:	01 c6                	add    %eax,%esi
80105934:	eb 14                	jmp    8010594a <memcmp+0x2a>
80105936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105940:	83 c0 01             	add    $0x1,%eax
80105943:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105946:	39 f0                	cmp    %esi,%eax
80105948:	74 16                	je     80105960 <memcmp+0x40>
    if(*s1 != *s2)
8010594a:	0f b6 0a             	movzbl (%edx),%ecx
8010594d:	0f b6 18             	movzbl (%eax),%ebx
80105950:	38 d9                	cmp    %bl,%cl
80105952:	74 ec                	je     80105940 <memcmp+0x20>
      return *s1 - *s2;
80105954:	0f b6 c1             	movzbl %cl,%eax
80105957:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105959:	5b                   	pop    %ebx
8010595a:	5e                   	pop    %esi
8010595b:	5d                   	pop    %ebp
8010595c:	c3                   	ret    
8010595d:	8d 76 00             	lea    0x0(%esi),%esi
80105960:	5b                   	pop    %ebx
  return 0;
80105961:	31 c0                	xor    %eax,%eax
}
80105963:	5e                   	pop    %esi
80105964:	5d                   	pop    %ebp
80105965:	c3                   	ret    
80105966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	8b 55 08             	mov    0x8(%ebp),%edx
80105977:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010597a:	56                   	push   %esi
8010597b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010597e:	39 d6                	cmp    %edx,%esi
80105980:	73 26                	jae    801059a8 <memmove+0x38>
80105982:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105985:	39 fa                	cmp    %edi,%edx
80105987:	73 1f                	jae    801059a8 <memmove+0x38>
80105989:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010598c:	85 c9                	test   %ecx,%ecx
8010598e:	74 0c                	je     8010599c <memmove+0x2c>
      *--d = *--s;
80105990:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105994:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105997:	83 e8 01             	sub    $0x1,%eax
8010599a:	73 f4                	jae    80105990 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010599c:	5e                   	pop    %esi
8010599d:	89 d0                	mov    %edx,%eax
8010599f:	5f                   	pop    %edi
801059a0:	5d                   	pop    %ebp
801059a1:	c3                   	ret    
801059a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801059a8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801059ab:	89 d7                	mov    %edx,%edi
801059ad:	85 c9                	test   %ecx,%ecx
801059af:	74 eb                	je     8010599c <memmove+0x2c>
801059b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801059b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801059b9:	39 c6                	cmp    %eax,%esi
801059bb:	75 fb                	jne    801059b8 <memmove+0x48>
}
801059bd:	5e                   	pop    %esi
801059be:	89 d0                	mov    %edx,%eax
801059c0:	5f                   	pop    %edi
801059c1:	5d                   	pop    %ebp
801059c2:	c3                   	ret    
801059c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801059d0:	eb 9e                	jmp    80105970 <memmove>
801059d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	56                   	push   %esi
801059e4:	8b 75 10             	mov    0x10(%ebp),%esi
801059e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801059ea:	53                   	push   %ebx
801059eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801059ee:	85 f6                	test   %esi,%esi
801059f0:	74 2e                	je     80105a20 <strncmp+0x40>
801059f2:	01 d6                	add    %edx,%esi
801059f4:	eb 18                	jmp    80105a0e <strncmp+0x2e>
801059f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
80105a00:	38 d8                	cmp    %bl,%al
80105a02:	75 14                	jne    80105a18 <strncmp+0x38>
    n--, p++, q++;
80105a04:	83 c2 01             	add    $0x1,%edx
80105a07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105a0a:	39 f2                	cmp    %esi,%edx
80105a0c:	74 12                	je     80105a20 <strncmp+0x40>
80105a0e:	0f b6 01             	movzbl (%ecx),%eax
80105a11:	0f b6 1a             	movzbl (%edx),%ebx
80105a14:	84 c0                	test   %al,%al
80105a16:	75 e8                	jne    80105a00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105a18:	29 d8                	sub    %ebx,%eax
}
80105a1a:	5b                   	pop    %ebx
80105a1b:	5e                   	pop    %esi
80105a1c:	5d                   	pop    %ebp
80105a1d:	c3                   	ret    
80105a1e:	66 90                	xchg   %ax,%ax
80105a20:	5b                   	pop    %ebx
    return 0;
80105a21:	31 c0                	xor    %eax,%eax
}
80105a23:	5e                   	pop    %esi
80105a24:	5d                   	pop    %ebp
80105a25:	c3                   	ret    
80105a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2d:	8d 76 00             	lea    0x0(%esi),%esi

80105a30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	8b 75 08             	mov    0x8(%ebp),%esi
80105a38:	53                   	push   %ebx
80105a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105a3c:	89 f0                	mov    %esi,%eax
80105a3e:	eb 15                	jmp    80105a55 <strncpy+0x25>
80105a40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105a47:	83 c0 01             	add    $0x1,%eax
80105a4a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105a4e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105a51:	84 d2                	test   %dl,%dl
80105a53:	74 09                	je     80105a5e <strncpy+0x2e>
80105a55:	89 cb                	mov    %ecx,%ebx
80105a57:	83 e9 01             	sub    $0x1,%ecx
80105a5a:	85 db                	test   %ebx,%ebx
80105a5c:	7f e2                	jg     80105a40 <strncpy+0x10>
    ;
  while(n-- > 0)
80105a5e:	89 c2                	mov    %eax,%edx
80105a60:	85 c9                	test   %ecx,%ecx
80105a62:	7e 17                	jle    80105a7b <strncpy+0x4b>
80105a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105a68:	83 c2 01             	add    $0x1,%edx
80105a6b:	89 c1                	mov    %eax,%ecx
80105a6d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105a71:	29 d1                	sub    %edx,%ecx
80105a73:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105a77:	85 c9                	test   %ecx,%ecx
80105a79:	7f ed                	jg     80105a68 <strncpy+0x38>
  return os;
}
80105a7b:	5b                   	pop    %ebx
80105a7c:	89 f0                	mov    %esi,%eax
80105a7e:	5e                   	pop    %esi
80105a7f:	5f                   	pop    %edi
80105a80:	5d                   	pop    %ebp
80105a81:	c3                   	ret    
80105a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	56                   	push   %esi
80105a94:	8b 55 10             	mov    0x10(%ebp),%edx
80105a97:	8b 75 08             	mov    0x8(%ebp),%esi
80105a9a:	53                   	push   %ebx
80105a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105a9e:	85 d2                	test   %edx,%edx
80105aa0:	7e 25                	jle    80105ac7 <safestrcpy+0x37>
80105aa2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105aa6:	89 f2                	mov    %esi,%edx
80105aa8:	eb 16                	jmp    80105ac0 <safestrcpy+0x30>
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105ab0:	0f b6 08             	movzbl (%eax),%ecx
80105ab3:	83 c0 01             	add    $0x1,%eax
80105ab6:	83 c2 01             	add    $0x1,%edx
80105ab9:	88 4a ff             	mov    %cl,-0x1(%edx)
80105abc:	84 c9                	test   %cl,%cl
80105abe:	74 04                	je     80105ac4 <safestrcpy+0x34>
80105ac0:	39 d8                	cmp    %ebx,%eax
80105ac2:	75 ec                	jne    80105ab0 <safestrcpy+0x20>
    ;
  *s = 0;
80105ac4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105ac7:	89 f0                	mov    %esi,%eax
80105ac9:	5b                   	pop    %ebx
80105aca:	5e                   	pop    %esi
80105acb:	5d                   	pop    %ebp
80105acc:	c3                   	ret    
80105acd:	8d 76 00             	lea    0x0(%esi),%esi

80105ad0 <strlen>:

int
strlen(const char *s)
{
80105ad0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105ad1:	31 c0                	xor    %eax,%eax
{
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105ad8:	80 3a 00             	cmpb   $0x0,(%edx)
80105adb:	74 0c                	je     80105ae9 <strlen+0x19>
80105add:	8d 76 00             	lea    0x0(%esi),%esi
80105ae0:	83 c0 01             	add    $0x1,%eax
80105ae3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105ae7:	75 f7                	jne    80105ae0 <strlen+0x10>
    ;
  return n;
}
80105ae9:	5d                   	pop    %ebp
80105aea:	c3                   	ret    

80105aeb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105aeb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105aef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105af3:	55                   	push   %ebp
  pushl %ebx
80105af4:	53                   	push   %ebx
  pushl %esi
80105af5:	56                   	push   %esi
  pushl %edi
80105af6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105af7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105af9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105afb:	5f                   	pop    %edi
  popl %esi
80105afc:	5e                   	pop    %esi
  popl %ebx
80105afd:	5b                   	pop    %ebx
  popl %ebp
80105afe:	5d                   	pop    %ebp
  ret
80105aff:	c3                   	ret    

80105b00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 04             	sub    $0x4,%esp
80105b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b0a:	e8 a1 e7 ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b0f:	8b 00                	mov    (%eax),%eax
80105b11:	39 d8                	cmp    %ebx,%eax
80105b13:	76 1b                	jbe    80105b30 <fetchint+0x30>
80105b15:	8d 53 04             	lea    0x4(%ebx),%edx
80105b18:	39 d0                	cmp    %edx,%eax
80105b1a:	72 14                	jb     80105b30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1f:	8b 13                	mov    (%ebx),%edx
80105b21:	89 10                	mov    %edx,(%eax)
  return 0;
80105b23:	31 c0                	xor    %eax,%eax
}
80105b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b35:	eb ee                	jmp    80105b25 <fetchint+0x25>
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 04             	sub    $0x4,%esp
80105b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105b4a:	e8 61 e7 ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz)
80105b4f:	39 18                	cmp    %ebx,(%eax)
80105b51:	76 2d                	jbe    80105b80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105b58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105b5a:	39 d3                	cmp    %edx,%ebx
80105b5c:	73 22                	jae    80105b80 <fetchstr+0x40>
80105b5e:	89 d8                	mov    %ebx,%eax
80105b60:	eb 0d                	jmp    80105b6f <fetchstr+0x2f>
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b68:	83 c0 01             	add    $0x1,%eax
80105b6b:	39 c2                	cmp    %eax,%edx
80105b6d:	76 11                	jbe    80105b80 <fetchstr+0x40>
    if(*s == 0)
80105b6f:	80 38 00             	cmpb   $0x0,(%eax)
80105b72:	75 f4                	jne    80105b68 <fetchstr+0x28>
      return s - *pp;
80105b74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b79:	c9                   	leave  
80105b7a:	c3                   	ret    
80105b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
80105b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	56                   	push   %esi
80105b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b95:	e8 16 e7 ff ff       	call   801042b0 <myproc>
80105b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80105b9d:	8b 40 18             	mov    0x18(%eax),%eax
80105ba0:	8b 40 44             	mov    0x44(%eax),%eax
80105ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ba6:	e8 05 e7 ff ff       	call   801042b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105bae:	8b 00                	mov    (%eax),%eax
80105bb0:	39 c6                	cmp    %eax,%esi
80105bb2:	73 1c                	jae    80105bd0 <argint+0x40>
80105bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80105bb7:	39 d0                	cmp    %edx,%eax
80105bb9:	72 15                	jb     80105bd0 <argint+0x40>
  *ip = *(int*)(addr);
80105bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bbe:	8b 53 04             	mov    0x4(%ebx),%edx
80105bc1:	89 10                	mov    %edx,(%eax)
  return 0;
80105bc3:	31 c0                	xor    %eax,%eax
}
80105bc5:	5b                   	pop    %ebx
80105bc6:	5e                   	pop    %esi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bd5:	eb ee                	jmp    80105bc5 <argint+0x35>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
80105be6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105be9:	e8 c2 e6 ff ff       	call   801042b0 <myproc>
80105bee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bf0:	e8 bb e6 ff ff       	call   801042b0 <myproc>
80105bf5:	8b 55 08             	mov    0x8(%ebp),%edx
80105bf8:	8b 40 18             	mov    0x18(%eax),%eax
80105bfb:	8b 40 44             	mov    0x44(%eax),%eax
80105bfe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c01:	e8 aa e6 ff ff       	call   801042b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c09:	8b 00                	mov    (%eax),%eax
80105c0b:	39 c7                	cmp    %eax,%edi
80105c0d:	73 31                	jae    80105c40 <argptr+0x60>
80105c0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105c12:	39 c8                	cmp    %ecx,%eax
80105c14:	72 2a                	jb     80105c40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105c19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c1c:	85 d2                	test   %edx,%edx
80105c1e:	78 20                	js     80105c40 <argptr+0x60>
80105c20:	8b 16                	mov    (%esi),%edx
80105c22:	39 c2                	cmp    %eax,%edx
80105c24:	76 1a                	jbe    80105c40 <argptr+0x60>
80105c26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105c29:	01 c3                	add    %eax,%ebx
80105c2b:	39 da                	cmp    %ebx,%edx
80105c2d:	72 11                	jb     80105c40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c32:	89 02                	mov    %eax,(%edx)
  return 0;
80105c34:	31 c0                	xor    %eax,%eax
}
80105c36:	83 c4 0c             	add    $0xc,%esp
80105c39:	5b                   	pop    %ebx
80105c3a:	5e                   	pop    %esi
80105c3b:	5f                   	pop    %edi
80105c3c:	5d                   	pop    %ebp
80105c3d:	c3                   	ret    
80105c3e:	66 90                	xchg   %ax,%ax
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c45:	eb ef                	jmp    80105c36 <argptr+0x56>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	56                   	push   %esi
80105c54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c55:	e8 56 e6 ff ff       	call   801042b0 <myproc>
80105c5a:	8b 55 08             	mov    0x8(%ebp),%edx
80105c5d:	8b 40 18             	mov    0x18(%eax),%eax
80105c60:	8b 40 44             	mov    0x44(%eax),%eax
80105c63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c66:	e8 45 e6 ff ff       	call   801042b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c6e:	8b 00                	mov    (%eax),%eax
80105c70:	39 c6                	cmp    %eax,%esi
80105c72:	73 44                	jae    80105cb8 <argstr+0x68>
80105c74:	8d 53 08             	lea    0x8(%ebx),%edx
80105c77:	39 d0                	cmp    %edx,%eax
80105c79:	72 3d                	jb     80105cb8 <argstr+0x68>
  *ip = *(int*)(addr);
80105c7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105c7e:	e8 2d e6 ff ff       	call   801042b0 <myproc>
  if(addr >= curproc->sz)
80105c83:	3b 18                	cmp    (%eax),%ebx
80105c85:	73 31                	jae    80105cb8 <argstr+0x68>
  *pp = (char*)addr;
80105c87:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105c8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105c8e:	39 d3                	cmp    %edx,%ebx
80105c90:	73 26                	jae    80105cb8 <argstr+0x68>
80105c92:	89 d8                	mov    %ebx,%eax
80105c94:	eb 11                	jmp    80105ca7 <argstr+0x57>
80105c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
80105ca0:	83 c0 01             	add    $0x1,%eax
80105ca3:	39 c2                	cmp    %eax,%edx
80105ca5:	76 11                	jbe    80105cb8 <argstr+0x68>
    if(*s == 0)
80105ca7:	80 38 00             	cmpb   $0x0,(%eax)
80105caa:	75 f4                	jne    80105ca0 <argstr+0x50>
      return s - *pp;
80105cac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105cae:	5b                   	pop    %ebx
80105caf:	5e                   	pop    %esi
80105cb0:	5d                   	pop    %ebp
80105cb1:	c3                   	ret    
80105cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cb8:	5b                   	pop    %ebx
    return -1;
80105cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbe:	5e                   	pop    %esi
80105cbf:	5d                   	pop    %ebp
80105cc0:	c3                   	ret    
80105cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop

80105cd0 <syscall>:
[SYS_getCurrentPID] sys_getCurrentPID,
};

void
syscall(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
80105cd4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105cd7:	e8 d4 e5 ff ff       	call   801042b0 <myproc>
80105cdc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105cde:	8b 40 18             	mov    0x18(%eax),%eax
80105ce1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105ce4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ce7:	83 fa 1f             	cmp    $0x1f,%edx
80105cea:	77 24                	ja     80105d10 <syscall+0x40>
80105cec:	8b 14 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%edx
80105cf3:	85 d2                	test   %edx,%edx
80105cf5:	74 19                	je     80105d10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105cf7:	ff d2                	call   *%edx
80105cf9:	89 c2                	mov    %eax,%edx
80105cfb:	8b 43 18             	mov    0x18(%ebx),%eax
80105cfe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d04:	c9                   	leave  
80105d05:	c3                   	ret    
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105d10:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105d11:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105d14:	50                   	push   %eax
80105d15:	ff 73 10             	push   0x10(%ebx)
80105d18:	68 d1 8c 10 80       	push   $0x80108cd1
80105d1d:	e8 7e a9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105d22:	8b 43 18             	mov    0x18(%ebx),%eax
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d32:	c9                   	leave  
80105d33:	c3                   	ret    
80105d34:	66 90                	xchg   %ax,%ax
80105d36:	66 90                	xchg   %ax,%ax
80105d38:	66 90                	xchg   %ax,%ax
80105d3a:	66 90                	xchg   %ax,%ax
80105d3c:	66 90                	xchg   %ax,%ax
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105d48:	53                   	push   %ebx
80105d49:	83 ec 34             	sub    $0x34,%esp
80105d4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d52:	57                   	push   %edi
80105d53:	50                   	push   %eax
{
80105d54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105d57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d5a:	e8 61 c3 ff ff       	call   801020c0 <nameiparent>
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	85 c0                	test   %eax,%eax
80105d64:	0f 84 46 01 00 00    	je     80105eb0 <create+0x170>
    return 0;
  ilock(dp);
80105d6a:	83 ec 0c             	sub    $0xc,%esp
80105d6d:	89 c3                	mov    %eax,%ebx
80105d6f:	50                   	push   %eax
80105d70:	e8 0b ba ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d75:	83 c4 0c             	add    $0xc,%esp
80105d78:	6a 00                	push   $0x0
80105d7a:	57                   	push   %edi
80105d7b:	53                   	push   %ebx
80105d7c:	e8 5f bf ff ff       	call   80101ce0 <dirlookup>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	89 c6                	mov    %eax,%esi
80105d86:	85 c0                	test   %eax,%eax
80105d88:	74 56                	je     80105de0 <create+0xa0>
    iunlockput(dp);
80105d8a:	83 ec 0c             	sub    $0xc,%esp
80105d8d:	53                   	push   %ebx
80105d8e:	e8 7d bc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105d93:	89 34 24             	mov    %esi,(%esp)
80105d96:	e8 e5 b9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105da3:	75 1b                	jne    80105dc0 <create+0x80>
80105da5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105daa:	75 14                	jne    80105dc0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105daf:	89 f0                	mov    %esi,%eax
80105db1:	5b                   	pop    %ebx
80105db2:	5e                   	pop    %esi
80105db3:	5f                   	pop    %edi
80105db4:	5d                   	pop    %ebp
80105db5:	c3                   	ret    
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	56                   	push   %esi
    return 0;
80105dc4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105dc6:	e8 45 bc ff ff       	call   80101a10 <iunlockput>
    return 0;
80105dcb:	83 c4 10             	add    $0x10,%esp
}
80105dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd1:	89 f0                	mov    %esi,%eax
80105dd3:	5b                   	pop    %ebx
80105dd4:	5e                   	pop    %esi
80105dd5:	5f                   	pop    %edi
80105dd6:	5d                   	pop    %ebp
80105dd7:	c3                   	ret    
80105dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105de0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105de4:	83 ec 08             	sub    $0x8,%esp
80105de7:	50                   	push   %eax
80105de8:	ff 33                	push   (%ebx)
80105dea:	e8 21 b8 ff ff       	call   80101610 <ialloc>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	89 c6                	mov    %eax,%esi
80105df4:	85 c0                	test   %eax,%eax
80105df6:	0f 84 cd 00 00 00    	je     80105ec9 <create+0x189>
  ilock(ip);
80105dfc:	83 ec 0c             	sub    $0xc,%esp
80105dff:	50                   	push   %eax
80105e00:	e8 7b b9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105e05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105e0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105e15:	b8 01 00 00 00       	mov    $0x1,%eax
80105e1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105e1e:	89 34 24             	mov    %esi,(%esp)
80105e21:	e8 aa b8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e2e:	74 30                	je     80105e60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105e30:	83 ec 04             	sub    $0x4,%esp
80105e33:	ff 76 04             	push   0x4(%esi)
80105e36:	57                   	push   %edi
80105e37:	53                   	push   %ebx
80105e38:	e8 a3 c1 ff ff       	call   80101fe0 <dirlink>
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	85 c0                	test   %eax,%eax
80105e42:	78 78                	js     80105ebc <create+0x17c>
  iunlockput(dp);
80105e44:	83 ec 0c             	sub    $0xc,%esp
80105e47:	53                   	push   %ebx
80105e48:	e8 c3 bb ff ff       	call   80101a10 <iunlockput>
  return ip;
80105e4d:	83 c4 10             	add    $0x10,%esp
}
80105e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e53:	89 f0                	mov    %esi,%eax
80105e55:	5b                   	pop    %ebx
80105e56:	5e                   	pop    %esi
80105e57:	5f                   	pop    %edi
80105e58:	5d                   	pop    %ebp
80105e59:	c3                   	ret    
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105e60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105e63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e68:	53                   	push   %ebx
80105e69:	e8 62 b8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e6e:	83 c4 0c             	add    $0xc,%esp
80105e71:	ff 76 04             	push   0x4(%esi)
80105e74:	68 a0 8d 10 80       	push   $0x80108da0
80105e79:	56                   	push   %esi
80105e7a:	e8 61 c1 ff ff       	call   80101fe0 <dirlink>
80105e7f:	83 c4 10             	add    $0x10,%esp
80105e82:	85 c0                	test   %eax,%eax
80105e84:	78 18                	js     80105e9e <create+0x15e>
80105e86:	83 ec 04             	sub    $0x4,%esp
80105e89:	ff 73 04             	push   0x4(%ebx)
80105e8c:	68 9f 8d 10 80       	push   $0x80108d9f
80105e91:	56                   	push   %esi
80105e92:	e8 49 c1 ff ff       	call   80101fe0 <dirlink>
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	79 92                	jns    80105e30 <create+0xf0>
      panic("create dots");
80105e9e:	83 ec 0c             	sub    $0xc,%esp
80105ea1:	68 93 8d 10 80       	push   $0x80108d93
80105ea6:	e8 d5 a4 ff ff       	call   80100380 <panic>
80105eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop
}
80105eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105eb3:	31 f6                	xor    %esi,%esi
}
80105eb5:	5b                   	pop    %ebx
80105eb6:	89 f0                	mov    %esi,%eax
80105eb8:	5e                   	pop    %esi
80105eb9:	5f                   	pop    %edi
80105eba:	5d                   	pop    %ebp
80105ebb:	c3                   	ret    
    panic("create: dirlink");
80105ebc:	83 ec 0c             	sub    $0xc,%esp
80105ebf:	68 a2 8d 10 80       	push   $0x80108da2
80105ec4:	e8 b7 a4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105ec9:	83 ec 0c             	sub    $0xc,%esp
80105ecc:	68 84 8d 10 80       	push   $0x80108d84
80105ed1:	e8 aa a4 ff ff       	call   80100380 <panic>
80105ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edd:	8d 76 00             	lea    0x0(%esi),%esi

80105ee0 <sys_dup>:
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	56                   	push   %esi
80105ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105eeb:	50                   	push   %eax
80105eec:	6a 00                	push   $0x0
80105eee:	e8 9d fc ff ff       	call   80105b90 <argint>
80105ef3:	83 c4 10             	add    $0x10,%esp
80105ef6:	85 c0                	test   %eax,%eax
80105ef8:	78 36                	js     80105f30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105efe:	77 30                	ja     80105f30 <sys_dup+0x50>
80105f00:	e8 ab e3 ff ff       	call   801042b0 <myproc>
80105f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105f0c:	85 f6                	test   %esi,%esi
80105f0e:	74 20                	je     80105f30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105f10:	e8 9b e3 ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f15:	31 db                	xor    %ebx,%ebx
80105f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105f20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f24:	85 d2                	test   %edx,%edx
80105f26:	74 18                	je     80105f40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105f28:	83 c3 01             	add    $0x1,%ebx
80105f2b:	83 fb 10             	cmp    $0x10,%ebx
80105f2e:	75 f0                	jne    80105f20 <sys_dup+0x40>
}
80105f30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105f33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105f38:	89 d8                	mov    %ebx,%eax
80105f3a:	5b                   	pop    %ebx
80105f3b:	5e                   	pop    %esi
80105f3c:	5d                   	pop    %ebp
80105f3d:	c3                   	ret    
80105f3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105f40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105f47:	56                   	push   %esi
80105f48:	e8 53 af ff ff       	call   80100ea0 <filedup>
  return fd;
80105f4d:	83 c4 10             	add    $0x10,%esp
}
80105f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f53:	89 d8                	mov    %ebx,%eax
80105f55:	5b                   	pop    %ebx
80105f56:	5e                   	pop    %esi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_read>:
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	56                   	push   %esi
80105f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f6b:	53                   	push   %ebx
80105f6c:	6a 00                	push   $0x0
80105f6e:	e8 1d fc ff ff       	call   80105b90 <argint>
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 c0                	test   %eax,%eax
80105f78:	78 5e                	js     80105fd8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f7e:	77 58                	ja     80105fd8 <sys_read+0x78>
80105f80:	e8 2b e3 ff ff       	call   801042b0 <myproc>
80105f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105f8c:	85 f6                	test   %esi,%esi
80105f8e:	74 48                	je     80105fd8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f90:	83 ec 08             	sub    $0x8,%esp
80105f93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f96:	50                   	push   %eax
80105f97:	6a 02                	push   $0x2
80105f99:	e8 f2 fb ff ff       	call   80105b90 <argint>
80105f9e:	83 c4 10             	add    $0x10,%esp
80105fa1:	85 c0                	test   %eax,%eax
80105fa3:	78 33                	js     80105fd8 <sys_read+0x78>
80105fa5:	83 ec 04             	sub    $0x4,%esp
80105fa8:	ff 75 f0             	push   -0x10(%ebp)
80105fab:	53                   	push   %ebx
80105fac:	6a 01                	push   $0x1
80105fae:	e8 2d fc ff ff       	call   80105be0 <argptr>
80105fb3:	83 c4 10             	add    $0x10,%esp
80105fb6:	85 c0                	test   %eax,%eax
80105fb8:	78 1e                	js     80105fd8 <sys_read+0x78>
  return fileread(f, p, n);
80105fba:	83 ec 04             	sub    $0x4,%esp
80105fbd:	ff 75 f0             	push   -0x10(%ebp)
80105fc0:	ff 75 f4             	push   -0xc(%ebp)
80105fc3:	56                   	push   %esi
80105fc4:	e8 57 b0 ff ff       	call   80101020 <fileread>
80105fc9:	83 c4 10             	add    $0x10,%esp
}
80105fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fcf:	5b                   	pop    %ebx
80105fd0:	5e                   	pop    %esi
80105fd1:	5d                   	pop    %ebp
80105fd2:	c3                   	ret    
80105fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fd7:	90                   	nop
    return -1;
80105fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdd:	eb ed                	jmp    80105fcc <sys_read+0x6c>
80105fdf:	90                   	nop

80105fe0 <sys_write>:
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	56                   	push   %esi
80105fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105feb:	53                   	push   %ebx
80105fec:	6a 00                	push   $0x0
80105fee:	e8 9d fb ff ff       	call   80105b90 <argint>
80105ff3:	83 c4 10             	add    $0x10,%esp
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	78 5e                	js     80106058 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105ffe:	77 58                	ja     80106058 <sys_write+0x78>
80106000:	e8 ab e2 ff ff       	call   801042b0 <myproc>
80106005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010600c:	85 f6                	test   %esi,%esi
8010600e:	74 48                	je     80106058 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106010:	83 ec 08             	sub    $0x8,%esp
80106013:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106016:	50                   	push   %eax
80106017:	6a 02                	push   $0x2
80106019:	e8 72 fb ff ff       	call   80105b90 <argint>
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	85 c0                	test   %eax,%eax
80106023:	78 33                	js     80106058 <sys_write+0x78>
80106025:	83 ec 04             	sub    $0x4,%esp
80106028:	ff 75 f0             	push   -0x10(%ebp)
8010602b:	53                   	push   %ebx
8010602c:	6a 01                	push   $0x1
8010602e:	e8 ad fb ff ff       	call   80105be0 <argptr>
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	85 c0                	test   %eax,%eax
80106038:	78 1e                	js     80106058 <sys_write+0x78>
  return filewrite(f, p, n);
8010603a:	83 ec 04             	sub    $0x4,%esp
8010603d:	ff 75 f0             	push   -0x10(%ebp)
80106040:	ff 75 f4             	push   -0xc(%ebp)
80106043:	56                   	push   %esi
80106044:	e8 67 b0 ff ff       	call   801010b0 <filewrite>
80106049:	83 c4 10             	add    $0x10,%esp
}
8010604c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010604f:	5b                   	pop    %ebx
80106050:	5e                   	pop    %esi
80106051:	5d                   	pop    %ebp
80106052:	c3                   	ret    
80106053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106057:	90                   	nop
    return -1;
80106058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605d:	eb ed                	jmp    8010604c <sys_write+0x6c>
8010605f:	90                   	nop

80106060 <sys_close>:
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	56                   	push   %esi
80106064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106065:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010606b:	50                   	push   %eax
8010606c:	6a 00                	push   $0x0
8010606e:	e8 1d fb ff ff       	call   80105b90 <argint>
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	85 c0                	test   %eax,%eax
80106078:	78 3e                	js     801060b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010607a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010607e:	77 38                	ja     801060b8 <sys_close+0x58>
80106080:	e8 2b e2 ff ff       	call   801042b0 <myproc>
80106085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106088:	8d 5a 08             	lea    0x8(%edx),%ebx
8010608b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010608f:	85 f6                	test   %esi,%esi
80106091:	74 25                	je     801060b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106093:	e8 18 e2 ff ff       	call   801042b0 <myproc>
  fileclose(f);
80106098:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010609b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801060a2:	00 
  fileclose(f);
801060a3:	56                   	push   %esi
801060a4:	e8 47 ae ff ff       	call   80100ef0 <fileclose>
  return 0;
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	31 c0                	xor    %eax,%eax
}
801060ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060b1:	5b                   	pop    %ebx
801060b2:	5e                   	pop    %esi
801060b3:	5d                   	pop    %ebp
801060b4:	c3                   	ret    
801060b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bd:	eb ef                	jmp    801060ae <sys_close+0x4e>
801060bf:	90                   	nop

801060c0 <sys_fstat>:
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	56                   	push   %esi
801060c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801060c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801060c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801060cb:	53                   	push   %ebx
801060cc:	6a 00                	push   $0x0
801060ce:	e8 bd fa ff ff       	call   80105b90 <argint>
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	85 c0                	test   %eax,%eax
801060d8:	78 46                	js     80106120 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801060da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801060de:	77 40                	ja     80106120 <sys_fstat+0x60>
801060e0:	e8 cb e1 ff ff       	call   801042b0 <myproc>
801060e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801060ec:	85 f6                	test   %esi,%esi
801060ee:	74 30                	je     80106120 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801060f0:	83 ec 04             	sub    $0x4,%esp
801060f3:	6a 14                	push   $0x14
801060f5:	53                   	push   %ebx
801060f6:	6a 01                	push   $0x1
801060f8:	e8 e3 fa ff ff       	call   80105be0 <argptr>
801060fd:	83 c4 10             	add    $0x10,%esp
80106100:	85 c0                	test   %eax,%eax
80106102:	78 1c                	js     80106120 <sys_fstat+0x60>
  return filestat(f, st);
80106104:	83 ec 08             	sub    $0x8,%esp
80106107:	ff 75 f4             	push   -0xc(%ebp)
8010610a:	56                   	push   %esi
8010610b:	e8 c0 ae ff ff       	call   80100fd0 <filestat>
80106110:	83 c4 10             	add    $0x10,%esp
}
80106113:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106116:	5b                   	pop    %ebx
80106117:	5e                   	pop    %esi
80106118:	5d                   	pop    %ebp
80106119:	c3                   	ret    
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106125:	eb ec                	jmp    80106113 <sys_fstat+0x53>
80106127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612e:	66 90                	xchg   %ax,%ax

80106130 <sys_link>:
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	57                   	push   %edi
80106134:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106135:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106138:	53                   	push   %ebx
80106139:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010613c:	50                   	push   %eax
8010613d:	6a 00                	push   $0x0
8010613f:	e8 0c fb ff ff       	call   80105c50 <argstr>
80106144:	83 c4 10             	add    $0x10,%esp
80106147:	85 c0                	test   %eax,%eax
80106149:	0f 88 fb 00 00 00    	js     8010624a <sys_link+0x11a>
8010614f:	83 ec 08             	sub    $0x8,%esp
80106152:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106155:	50                   	push   %eax
80106156:	6a 01                	push   $0x1
80106158:	e8 f3 fa ff ff       	call   80105c50 <argstr>
8010615d:	83 c4 10             	add    $0x10,%esp
80106160:	85 c0                	test   %eax,%eax
80106162:	0f 88 e2 00 00 00    	js     8010624a <sys_link+0x11a>
  begin_op();
80106168:	e8 f3 cb ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	ff 75 d4             	push   -0x2c(%ebp)
80106173:	e8 28 bf ff ff       	call   801020a0 <namei>
80106178:	83 c4 10             	add    $0x10,%esp
8010617b:	89 c3                	mov    %eax,%ebx
8010617d:	85 c0                	test   %eax,%eax
8010617f:	0f 84 e4 00 00 00    	je     80106269 <sys_link+0x139>
  ilock(ip);
80106185:	83 ec 0c             	sub    $0xc,%esp
80106188:	50                   	push   %eax
80106189:	e8 f2 b5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010618e:	83 c4 10             	add    $0x10,%esp
80106191:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106196:	0f 84 b5 00 00 00    	je     80106251 <sys_link+0x121>
  iupdate(ip);
8010619c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010619f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801061a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801061a7:	53                   	push   %ebx
801061a8:	e8 23 b5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801061ad:	89 1c 24             	mov    %ebx,(%esp)
801061b0:	e8 ab b6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801061b5:	58                   	pop    %eax
801061b6:	5a                   	pop    %edx
801061b7:	57                   	push   %edi
801061b8:	ff 75 d0             	push   -0x30(%ebp)
801061bb:	e8 00 bf ff ff       	call   801020c0 <nameiparent>
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	89 c6                	mov    %eax,%esi
801061c5:	85 c0                	test   %eax,%eax
801061c7:	74 5b                	je     80106224 <sys_link+0xf4>
  ilock(dp);
801061c9:	83 ec 0c             	sub    $0xc,%esp
801061cc:	50                   	push   %eax
801061cd:	e8 ae b5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061d2:	8b 03                	mov    (%ebx),%eax
801061d4:	83 c4 10             	add    $0x10,%esp
801061d7:	39 06                	cmp    %eax,(%esi)
801061d9:	75 3d                	jne    80106218 <sys_link+0xe8>
801061db:	83 ec 04             	sub    $0x4,%esp
801061de:	ff 73 04             	push   0x4(%ebx)
801061e1:	57                   	push   %edi
801061e2:	56                   	push   %esi
801061e3:	e8 f8 bd ff ff       	call   80101fe0 <dirlink>
801061e8:	83 c4 10             	add    $0x10,%esp
801061eb:	85 c0                	test   %eax,%eax
801061ed:	78 29                	js     80106218 <sys_link+0xe8>
  iunlockput(dp);
801061ef:	83 ec 0c             	sub    $0xc,%esp
801061f2:	56                   	push   %esi
801061f3:	e8 18 b8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801061f8:	89 1c 24             	mov    %ebx,(%esp)
801061fb:	e8 b0 b6 ff ff       	call   801018b0 <iput>
  end_op();
80106200:	e8 cb cb ff ff       	call   80102dd0 <end_op>
  return 0;
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	31 c0                	xor    %eax,%eax
}
8010620a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010620d:	5b                   	pop    %ebx
8010620e:	5e                   	pop    %esi
8010620f:	5f                   	pop    %edi
80106210:	5d                   	pop    %ebp
80106211:	c3                   	ret    
80106212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106218:	83 ec 0c             	sub    $0xc,%esp
8010621b:	56                   	push   %esi
8010621c:	e8 ef b7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80106221:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106224:	83 ec 0c             	sub    $0xc,%esp
80106227:	53                   	push   %ebx
80106228:	e8 53 b5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010622d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106232:	89 1c 24             	mov    %ebx,(%esp)
80106235:	e8 96 b4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010623a:	89 1c 24             	mov    %ebx,(%esp)
8010623d:	e8 ce b7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106242:	e8 89 cb ff ff       	call   80102dd0 <end_op>
  return -1;
80106247:	83 c4 10             	add    $0x10,%esp
8010624a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624f:	eb b9                	jmp    8010620a <sys_link+0xda>
    iunlockput(ip);
80106251:	83 ec 0c             	sub    $0xc,%esp
80106254:	53                   	push   %ebx
80106255:	e8 b6 b7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010625a:	e8 71 cb ff ff       	call   80102dd0 <end_op>
    return -1;
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106267:	eb a1                	jmp    8010620a <sys_link+0xda>
    end_op();
80106269:	e8 62 cb ff ff       	call   80102dd0 <end_op>
    return -1;
8010626e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106273:	eb 95                	jmp    8010620a <sys_link+0xda>
80106275:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106280 <sys_unlink>:
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106285:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106288:	53                   	push   %ebx
80106289:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010628c:	50                   	push   %eax
8010628d:	6a 00                	push   $0x0
8010628f:	e8 bc f9 ff ff       	call   80105c50 <argstr>
80106294:	83 c4 10             	add    $0x10,%esp
80106297:	85 c0                	test   %eax,%eax
80106299:	0f 88 7a 01 00 00    	js     80106419 <sys_unlink+0x199>
  begin_op();
8010629f:	e8 bc ca ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801062a7:	83 ec 08             	sub    $0x8,%esp
801062aa:	53                   	push   %ebx
801062ab:	ff 75 c0             	push   -0x40(%ebp)
801062ae:	e8 0d be ff ff       	call   801020c0 <nameiparent>
801062b3:	83 c4 10             	add    $0x10,%esp
801062b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801062b9:	85 c0                	test   %eax,%eax
801062bb:	0f 84 62 01 00 00    	je     80106423 <sys_unlink+0x1a3>
  ilock(dp);
801062c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801062c4:	83 ec 0c             	sub    $0xc,%esp
801062c7:	57                   	push   %edi
801062c8:	e8 b3 b4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801062cd:	58                   	pop    %eax
801062ce:	5a                   	pop    %edx
801062cf:	68 a0 8d 10 80       	push   $0x80108da0
801062d4:	53                   	push   %ebx
801062d5:	e8 e6 b9 ff ff       	call   80101cc0 <namecmp>
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	85 c0                	test   %eax,%eax
801062df:	0f 84 fb 00 00 00    	je     801063e0 <sys_unlink+0x160>
801062e5:	83 ec 08             	sub    $0x8,%esp
801062e8:	68 9f 8d 10 80       	push   $0x80108d9f
801062ed:	53                   	push   %ebx
801062ee:	e8 cd b9 ff ff       	call   80101cc0 <namecmp>
801062f3:	83 c4 10             	add    $0x10,%esp
801062f6:	85 c0                	test   %eax,%eax
801062f8:	0f 84 e2 00 00 00    	je     801063e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801062fe:	83 ec 04             	sub    $0x4,%esp
80106301:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106304:	50                   	push   %eax
80106305:	53                   	push   %ebx
80106306:	57                   	push   %edi
80106307:	e8 d4 b9 ff ff       	call   80101ce0 <dirlookup>
8010630c:	83 c4 10             	add    $0x10,%esp
8010630f:	89 c3                	mov    %eax,%ebx
80106311:	85 c0                	test   %eax,%eax
80106313:	0f 84 c7 00 00 00    	je     801063e0 <sys_unlink+0x160>
  ilock(ip);
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	50                   	push   %eax
8010631d:	e8 5e b4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010632a:	0f 8e 1c 01 00 00    	jle    8010644c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106330:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106335:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106338:	74 66                	je     801063a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010633a:	83 ec 04             	sub    $0x4,%esp
8010633d:	6a 10                	push   $0x10
8010633f:	6a 00                	push   $0x0
80106341:	57                   	push   %edi
80106342:	e8 89 f5 ff ff       	call   801058d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106347:	6a 10                	push   $0x10
80106349:	ff 75 c4             	push   -0x3c(%ebp)
8010634c:	57                   	push   %edi
8010634d:	ff 75 b4             	push   -0x4c(%ebp)
80106350:	e8 3b b8 ff ff       	call   80101b90 <writei>
80106355:	83 c4 20             	add    $0x20,%esp
80106358:	83 f8 10             	cmp    $0x10,%eax
8010635b:	0f 85 de 00 00 00    	jne    8010643f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106361:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106366:	0f 84 94 00 00 00    	je     80106400 <sys_unlink+0x180>
  iunlockput(dp);
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	ff 75 b4             	push   -0x4c(%ebp)
80106372:	e8 99 b6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80106377:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010637c:	89 1c 24             	mov    %ebx,(%esp)
8010637f:	e8 4c b3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80106384:	89 1c 24             	mov    %ebx,(%esp)
80106387:	e8 84 b6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010638c:	e8 3f ca ff ff       	call   80102dd0 <end_op>
  return 0;
80106391:	83 c4 10             	add    $0x10,%esp
80106394:	31 c0                	xor    %eax,%eax
}
80106396:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106399:	5b                   	pop    %ebx
8010639a:	5e                   	pop    %esi
8010639b:	5f                   	pop    %edi
8010639c:	5d                   	pop    %ebp
8010639d:	c3                   	ret    
8010639e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801063a4:	76 94                	jbe    8010633a <sys_unlink+0xba>
801063a6:	be 20 00 00 00       	mov    $0x20,%esi
801063ab:	eb 0b                	jmp    801063b8 <sys_unlink+0x138>
801063ad:	8d 76 00             	lea    0x0(%esi),%esi
801063b0:	83 c6 10             	add    $0x10,%esi
801063b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801063b6:	73 82                	jae    8010633a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063b8:	6a 10                	push   $0x10
801063ba:	56                   	push   %esi
801063bb:	57                   	push   %edi
801063bc:	53                   	push   %ebx
801063bd:	e8 ce b6 ff ff       	call   80101a90 <readi>
801063c2:	83 c4 10             	add    $0x10,%esp
801063c5:	83 f8 10             	cmp    $0x10,%eax
801063c8:	75 68                	jne    80106432 <sys_unlink+0x1b2>
    if(de.inum != 0)
801063ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801063cf:	74 df                	je     801063b0 <sys_unlink+0x130>
    iunlockput(ip);
801063d1:	83 ec 0c             	sub    $0xc,%esp
801063d4:	53                   	push   %ebx
801063d5:	e8 36 b6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	ff 75 b4             	push   -0x4c(%ebp)
801063e6:	e8 25 b6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801063eb:	e8 e0 c9 ff ff       	call   80102dd0 <end_op>
  return -1;
801063f0:	83 c4 10             	add    $0x10,%esp
801063f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f8:	eb 9c                	jmp    80106396 <sys_unlink+0x116>
801063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106400:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106403:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106406:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010640b:	50                   	push   %eax
8010640c:	e8 bf b2 ff ff       	call   801016d0 <iupdate>
80106411:	83 c4 10             	add    $0x10,%esp
80106414:	e9 53 ff ff ff       	jmp    8010636c <sys_unlink+0xec>
    return -1;
80106419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010641e:	e9 73 ff ff ff       	jmp    80106396 <sys_unlink+0x116>
    end_op();
80106423:	e8 a8 c9 ff ff       	call   80102dd0 <end_op>
    return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642d:	e9 64 ff ff ff       	jmp    80106396 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106432:	83 ec 0c             	sub    $0xc,%esp
80106435:	68 c4 8d 10 80       	push   $0x80108dc4
8010643a:	e8 41 9f ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010643f:	83 ec 0c             	sub    $0xc,%esp
80106442:	68 d6 8d 10 80       	push   $0x80108dd6
80106447:	e8 34 9f ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010644c:	83 ec 0c             	sub    $0xc,%esp
8010644f:	68 b2 8d 10 80       	push   $0x80108db2
80106454:	e8 27 9f ff ff       	call   80100380 <panic>
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <sys_open>:

int
sys_open(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	57                   	push   %edi
80106464:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106465:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106468:	53                   	push   %ebx
80106469:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010646c:	50                   	push   %eax
8010646d:	6a 00                	push   $0x0
8010646f:	e8 dc f7 ff ff       	call   80105c50 <argstr>
80106474:	83 c4 10             	add    $0x10,%esp
80106477:	85 c0                	test   %eax,%eax
80106479:	0f 88 8e 00 00 00    	js     8010650d <sys_open+0xad>
8010647f:	83 ec 08             	sub    $0x8,%esp
80106482:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106485:	50                   	push   %eax
80106486:	6a 01                	push   $0x1
80106488:	e8 03 f7 ff ff       	call   80105b90 <argint>
8010648d:	83 c4 10             	add    $0x10,%esp
80106490:	85 c0                	test   %eax,%eax
80106492:	78 79                	js     8010650d <sys_open+0xad>
    return -1;

  begin_op();
80106494:	e8 c7 c8 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80106499:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010649d:	75 79                	jne    80106518 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	ff 75 e0             	push   -0x20(%ebp)
801064a5:	e8 f6 bb ff ff       	call   801020a0 <namei>
801064aa:	83 c4 10             	add    $0x10,%esp
801064ad:	89 c6                	mov    %eax,%esi
801064af:	85 c0                	test   %eax,%eax
801064b1:	0f 84 7e 00 00 00    	je     80106535 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801064b7:	83 ec 0c             	sub    $0xc,%esp
801064ba:	50                   	push   %eax
801064bb:	e8 c0 b2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064c0:	83 c4 10             	add    $0x10,%esp
801064c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801064c8:	0f 84 c2 00 00 00    	je     80106590 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801064ce:	e8 5d a9 ff ff       	call   80100e30 <filealloc>
801064d3:	89 c7                	mov    %eax,%edi
801064d5:	85 c0                	test   %eax,%eax
801064d7:	74 23                	je     801064fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801064d9:	e8 d2 dd ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801064e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801064e4:	85 d2                	test   %edx,%edx
801064e6:	74 60                	je     80106548 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801064e8:	83 c3 01             	add    $0x1,%ebx
801064eb:	83 fb 10             	cmp    $0x10,%ebx
801064ee:	75 f0                	jne    801064e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	57                   	push   %edi
801064f4:	e8 f7 a9 ff ff       	call   80100ef0 <fileclose>
801064f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801064fc:	83 ec 0c             	sub    $0xc,%esp
801064ff:	56                   	push   %esi
80106500:	e8 0b b5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106505:	e8 c6 c8 ff ff       	call   80102dd0 <end_op>
    return -1;
8010650a:	83 c4 10             	add    $0x10,%esp
8010650d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106512:	eb 6d                	jmp    80106581 <sys_open+0x121>
80106514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106518:	83 ec 0c             	sub    $0xc,%esp
8010651b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010651e:	31 c9                	xor    %ecx,%ecx
80106520:	ba 02 00 00 00       	mov    $0x2,%edx
80106525:	6a 00                	push   $0x0
80106527:	e8 14 f8 ff ff       	call   80105d40 <create>
    if(ip == 0){
8010652c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010652f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106531:	85 c0                	test   %eax,%eax
80106533:	75 99                	jne    801064ce <sys_open+0x6e>
      end_op();
80106535:	e8 96 c8 ff ff       	call   80102dd0 <end_op>
      return -1;
8010653a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010653f:	eb 40                	jmp    80106581 <sys_open+0x121>
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106548:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010654b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010654f:	56                   	push   %esi
80106550:	e8 0b b3 ff ff       	call   80101860 <iunlock>
  end_op();
80106555:	e8 76 c8 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010655a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106563:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106566:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106569:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010656b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106572:	f7 d0                	not    %eax
80106574:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106577:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010657a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010657d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106584:	89 d8                	mov    %ebx,%eax
80106586:	5b                   	pop    %ebx
80106587:	5e                   	pop    %esi
80106588:	5f                   	pop    %edi
80106589:	5d                   	pop    %ebp
8010658a:	c3                   	ret    
8010658b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010658f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106593:	85 c9                	test   %ecx,%ecx
80106595:	0f 84 33 ff ff ff    	je     801064ce <sys_open+0x6e>
8010659b:	e9 5c ff ff ff       	jmp    801064fc <sys_open+0x9c>

801065a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065a6:	e8 b5 c7 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065ab:	83 ec 08             	sub    $0x8,%esp
801065ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b1:	50                   	push   %eax
801065b2:	6a 00                	push   $0x0
801065b4:	e8 97 f6 ff ff       	call   80105c50 <argstr>
801065b9:	83 c4 10             	add    $0x10,%esp
801065bc:	85 c0                	test   %eax,%eax
801065be:	78 30                	js     801065f0 <sys_mkdir+0x50>
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c6:	31 c9                	xor    %ecx,%ecx
801065c8:	ba 01 00 00 00       	mov    $0x1,%edx
801065cd:	6a 00                	push   $0x0
801065cf:	e8 6c f7 ff ff       	call   80105d40 <create>
801065d4:	83 c4 10             	add    $0x10,%esp
801065d7:	85 c0                	test   %eax,%eax
801065d9:	74 15                	je     801065f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801065db:	83 ec 0c             	sub    $0xc,%esp
801065de:	50                   	push   %eax
801065df:	e8 2c b4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801065e4:	e8 e7 c7 ff ff       	call   80102dd0 <end_op>
  return 0;
801065e9:	83 c4 10             	add    $0x10,%esp
801065ec:	31 c0                	xor    %eax,%eax
}
801065ee:	c9                   	leave  
801065ef:	c3                   	ret    
    end_op();
801065f0:	e8 db c7 ff ff       	call   80102dd0 <end_op>
    return -1;
801065f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065fa:	c9                   	leave  
801065fb:	c3                   	ret    
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106600 <sys_mknod>:

int
sys_mknod(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106606:	e8 55 c7 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010660b:	83 ec 08             	sub    $0x8,%esp
8010660e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106611:	50                   	push   %eax
80106612:	6a 00                	push   $0x0
80106614:	e8 37 f6 ff ff       	call   80105c50 <argstr>
80106619:	83 c4 10             	add    $0x10,%esp
8010661c:	85 c0                	test   %eax,%eax
8010661e:	78 60                	js     80106680 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106620:	83 ec 08             	sub    $0x8,%esp
80106623:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106626:	50                   	push   %eax
80106627:	6a 01                	push   $0x1
80106629:	e8 62 f5 ff ff       	call   80105b90 <argint>
  if((argstr(0, &path)) < 0 ||
8010662e:	83 c4 10             	add    $0x10,%esp
80106631:	85 c0                	test   %eax,%eax
80106633:	78 4b                	js     80106680 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010663b:	50                   	push   %eax
8010663c:	6a 02                	push   $0x2
8010663e:	e8 4d f5 ff ff       	call   80105b90 <argint>
     argint(1, &major) < 0 ||
80106643:	83 c4 10             	add    $0x10,%esp
80106646:	85 c0                	test   %eax,%eax
80106648:	78 36                	js     80106680 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010664a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010664e:	83 ec 0c             	sub    $0xc,%esp
80106651:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106655:	ba 03 00 00 00       	mov    $0x3,%edx
8010665a:	50                   	push   %eax
8010665b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010665e:	e8 dd f6 ff ff       	call   80105d40 <create>
     argint(2, &minor) < 0 ||
80106663:	83 c4 10             	add    $0x10,%esp
80106666:	85 c0                	test   %eax,%eax
80106668:	74 16                	je     80106680 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010666a:	83 ec 0c             	sub    $0xc,%esp
8010666d:	50                   	push   %eax
8010666e:	e8 9d b3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106673:	e8 58 c7 ff ff       	call   80102dd0 <end_op>
  return 0;
80106678:	83 c4 10             	add    $0x10,%esp
8010667b:	31 c0                	xor    %eax,%eax
}
8010667d:	c9                   	leave  
8010667e:	c3                   	ret    
8010667f:	90                   	nop
    end_op();
80106680:	e8 4b c7 ff ff       	call   80102dd0 <end_op>
    return -1;
80106685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010668a:	c9                   	leave  
8010668b:	c3                   	ret    
8010668c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106690 <sys_chdir>:

int
sys_chdir(void)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	56                   	push   %esi
80106694:	53                   	push   %ebx
80106695:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106698:	e8 13 dc ff ff       	call   801042b0 <myproc>
8010669d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010669f:	e8 bc c6 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066a4:	83 ec 08             	sub    $0x8,%esp
801066a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066aa:	50                   	push   %eax
801066ab:	6a 00                	push   $0x0
801066ad:	e8 9e f5 ff ff       	call   80105c50 <argstr>
801066b2:	83 c4 10             	add    $0x10,%esp
801066b5:	85 c0                	test   %eax,%eax
801066b7:	78 77                	js     80106730 <sys_chdir+0xa0>
801066b9:	83 ec 0c             	sub    $0xc,%esp
801066bc:	ff 75 f4             	push   -0xc(%ebp)
801066bf:	e8 dc b9 ff ff       	call   801020a0 <namei>
801066c4:	83 c4 10             	add    $0x10,%esp
801066c7:	89 c3                	mov    %eax,%ebx
801066c9:	85 c0                	test   %eax,%eax
801066cb:	74 63                	je     80106730 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801066cd:	83 ec 0c             	sub    $0xc,%esp
801066d0:	50                   	push   %eax
801066d1:	e8 aa b0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801066d6:	83 c4 10             	add    $0x10,%esp
801066d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801066de:	75 30                	jne    80106710 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801066e0:	83 ec 0c             	sub    $0xc,%esp
801066e3:	53                   	push   %ebx
801066e4:	e8 77 b1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801066e9:	58                   	pop    %eax
801066ea:	ff 76 68             	push   0x68(%esi)
801066ed:	e8 be b1 ff ff       	call   801018b0 <iput>
  end_op();
801066f2:	e8 d9 c6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
801066f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801066fa:	83 c4 10             	add    $0x10,%esp
801066fd:	31 c0                	xor    %eax,%eax
}
801066ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106702:	5b                   	pop    %ebx
80106703:	5e                   	pop    %esi
80106704:	5d                   	pop    %ebp
80106705:	c3                   	ret    
80106706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106710:	83 ec 0c             	sub    $0xc,%esp
80106713:	53                   	push   %ebx
80106714:	e8 f7 b2 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106719:	e8 b2 c6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010671e:	83 c4 10             	add    $0x10,%esp
80106721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106726:	eb d7                	jmp    801066ff <sys_chdir+0x6f>
80106728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010672f:	90                   	nop
    end_op();
80106730:	e8 9b c6 ff ff       	call   80102dd0 <end_op>
    return -1;
80106735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673a:	eb c3                	jmp    801066ff <sys_chdir+0x6f>
8010673c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106740 <sys_exec>:

int
sys_exec(void)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106745:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010674b:	53                   	push   %ebx
8010674c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106752:	50                   	push   %eax
80106753:	6a 00                	push   $0x0
80106755:	e8 f6 f4 ff ff       	call   80105c50 <argstr>
8010675a:	83 c4 10             	add    $0x10,%esp
8010675d:	85 c0                	test   %eax,%eax
8010675f:	0f 88 87 00 00 00    	js     801067ec <sys_exec+0xac>
80106765:	83 ec 08             	sub    $0x8,%esp
80106768:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010676e:	50                   	push   %eax
8010676f:	6a 01                	push   $0x1
80106771:	e8 1a f4 ff ff       	call   80105b90 <argint>
80106776:	83 c4 10             	add    $0x10,%esp
80106779:	85 c0                	test   %eax,%eax
8010677b:	78 6f                	js     801067ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010677d:	83 ec 04             	sub    $0x4,%esp
80106780:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106786:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106788:	68 80 00 00 00       	push   $0x80
8010678d:	6a 00                	push   $0x0
8010678f:	56                   	push   %esi
80106790:	e8 3b f1 ff ff       	call   801058d0 <memset>
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067a0:	83 ec 08             	sub    $0x8,%esp
801067a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801067a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801067b0:	50                   	push   %eax
801067b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801067b7:	01 f8                	add    %edi,%eax
801067b9:	50                   	push   %eax
801067ba:	e8 41 f3 ff ff       	call   80105b00 <fetchint>
801067bf:	83 c4 10             	add    $0x10,%esp
801067c2:	85 c0                	test   %eax,%eax
801067c4:	78 26                	js     801067ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801067c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801067cc:	85 c0                	test   %eax,%eax
801067ce:	74 30                	je     80106800 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801067d0:	83 ec 08             	sub    $0x8,%esp
801067d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801067d6:	52                   	push   %edx
801067d7:	50                   	push   %eax
801067d8:	e8 63 f3 ff ff       	call   80105b40 <fetchstr>
801067dd:	83 c4 10             	add    $0x10,%esp
801067e0:	85 c0                	test   %eax,%eax
801067e2:	78 08                	js     801067ec <sys_exec+0xac>
  for(i=0;; i++){
801067e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801067e7:	83 fb 20             	cmp    $0x20,%ebx
801067ea:	75 b4                	jne    801067a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801067ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801067ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067f4:	5b                   	pop    %ebx
801067f5:	5e                   	pop    %esi
801067f6:	5f                   	pop    %edi
801067f7:	5d                   	pop    %ebp
801067f8:	c3                   	ret    
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106800:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106807:	00 00 00 00 
  return exec(path, argv);
8010680b:	83 ec 08             	sub    $0x8,%esp
8010680e:	56                   	push   %esi
8010680f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106815:	e8 96 a2 ff ff       	call   80100ab0 <exec>
8010681a:	83 c4 10             	add    $0x10,%esp
}
8010681d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106820:	5b                   	pop    %ebx
80106821:	5e                   	pop    %esi
80106822:	5f                   	pop    %edi
80106823:	5d                   	pop    %ebp
80106824:	c3                   	ret    
80106825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106830 <sys_pipe>:

int
sys_pipe(void)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106835:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106838:	53                   	push   %ebx
80106839:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010683c:	6a 08                	push   $0x8
8010683e:	50                   	push   %eax
8010683f:	6a 00                	push   $0x0
80106841:	e8 9a f3 ff ff       	call   80105be0 <argptr>
80106846:	83 c4 10             	add    $0x10,%esp
80106849:	85 c0                	test   %eax,%eax
8010684b:	78 4a                	js     80106897 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010684d:	83 ec 08             	sub    $0x8,%esp
80106850:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106853:	50                   	push   %eax
80106854:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106857:	50                   	push   %eax
80106858:	e8 d3 cb ff ff       	call   80103430 <pipealloc>
8010685d:	83 c4 10             	add    $0x10,%esp
80106860:	85 c0                	test   %eax,%eax
80106862:	78 33                	js     80106897 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106864:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106867:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106869:	e8 42 da ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010686e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106870:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106874:	85 f6                	test   %esi,%esi
80106876:	74 28                	je     801068a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106878:	83 c3 01             	add    $0x1,%ebx
8010687b:	83 fb 10             	cmp    $0x10,%ebx
8010687e:	75 f0                	jne    80106870 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106880:	83 ec 0c             	sub    $0xc,%esp
80106883:	ff 75 e0             	push   -0x20(%ebp)
80106886:	e8 65 a6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010688b:	58                   	pop    %eax
8010688c:	ff 75 e4             	push   -0x1c(%ebp)
8010688f:	e8 5c a6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80106894:	83 c4 10             	add    $0x10,%esp
80106897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689c:	eb 53                	jmp    801068f1 <sys_pipe+0xc1>
8010689e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801068a0:	8d 73 08             	lea    0x8(%ebx),%esi
801068a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801068aa:	e8 01 da ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068af:	31 d2                	xor    %edx,%edx
801068b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801068b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801068bc:	85 c9                	test   %ecx,%ecx
801068be:	74 20                	je     801068e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801068c0:	83 c2 01             	add    $0x1,%edx
801068c3:	83 fa 10             	cmp    $0x10,%edx
801068c6:	75 f0                	jne    801068b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801068c8:	e8 e3 d9 ff ff       	call   801042b0 <myproc>
801068cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801068d4:	00 
801068d5:	eb a9                	jmp    80106880 <sys_pipe+0x50>
801068d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801068e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801068e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801068e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801068ef:	31 c0                	xor    %eax,%eax
}
801068f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f4:	5b                   	pop    %ebx
801068f5:	5e                   	pop    %esi
801068f6:	5f                   	pop    %edi
801068f7:	5d                   	pop    %ebp
801068f8:	c3                   	ret    
801068f9:	66 90                	xchg   %ax,%ax
801068fb:	66 90                	xchg   %ax,%ax
801068fd:	66 90                	xchg   %ax,%ax
801068ff:	90                   	nop

80106900 <sys_fork>:
#include "processInfo.h"

int
sys_fork(void)
{
  return fork();
80106900:	e9 eb db ff ff       	jmp    801044f0 <fork>
80106905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106910 <sys_exit>:
}

int
sys_exit(void)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 08             	sub    $0x8,%esp
  exit();
80106916:	e8 d5 df ff ff       	call   801048f0 <exit>
  return 0;  // not reached
}
8010691b:	31 c0                	xor    %eax,%eax
8010691d:	c9                   	leave  
8010691e:	c3                   	ret    
8010691f:	90                   	nop

80106920 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106920:	e9 bb e0 ff ff       	jmp    801049e0 <wait>
80106925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106930 <sys_kill>:
}

int
sys_kill(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106939:	50                   	push   %eax
8010693a:	6a 00                	push   $0x0
8010693c:	e8 4f f2 ff ff       	call   80105b90 <argint>
80106941:	83 c4 10             	add    $0x10,%esp
80106944:	85 c0                	test   %eax,%eax
80106946:	78 18                	js     80106960 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106948:	83 ec 0c             	sub    $0xc,%esp
8010694b:	ff 75 f4             	push   -0xc(%ebp)
8010694e:	e8 3d e4 ff ff       	call   80104d90 <kill>
80106953:	83 c4 10             	add    $0x10,%esp
}
80106956:	c9                   	leave  
80106957:	c3                   	ret    
80106958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010695f:	90                   	nop
80106960:	c9                   	leave  
    return -1;
80106961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106966:	c3                   	ret    
80106967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010696e:	66 90                	xchg   %ax,%ax

80106970 <sys_getpid>:

int
sys_getpid(void)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106976:	e8 35 d9 ff ff       	call   801042b0 <myproc>
8010697b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010697e:	c9                   	leave  
8010697f:	c3                   	ret    

80106980 <sys_sbrk>:

int
sys_sbrk(void)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106984:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106987:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010698a:	50                   	push   %eax
8010698b:	6a 00                	push   $0x0
8010698d:	e8 fe f1 ff ff       	call   80105b90 <argint>
80106992:	83 c4 10             	add    $0x10,%esp
80106995:	85 c0                	test   %eax,%eax
80106997:	78 27                	js     801069c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106999:	e8 12 d9 ff ff       	call   801042b0 <myproc>
  if(growproc(n) < 0)
8010699e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801069a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801069a3:	ff 75 f4             	push   -0xc(%ebp)
801069a6:	e8 c5 da ff ff       	call   80104470 <growproc>
801069ab:	83 c4 10             	add    $0x10,%esp
801069ae:	85 c0                	test   %eax,%eax
801069b0:	78 0e                	js     801069c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801069b2:	89 d8                	mov    %ebx,%eax
801069b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069b7:	c9                   	leave  
801069b8:	c3                   	ret    
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801069c5:	eb eb                	jmp    801069b2 <sys_sbrk+0x32>
801069c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ce:	66 90                	xchg   %ax,%ax

801069d0 <sys_sleep>:

int
sys_sleep(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801069d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801069da:	50                   	push   %eax
801069db:	6a 00                	push   $0x0
801069dd:	e8 ae f1 ff ff       	call   80105b90 <argint>
801069e2:	83 c4 10             	add    $0x10,%esp
801069e5:	85 c0                	test   %eax,%eax
801069e7:	0f 88 8a 00 00 00    	js     80106a77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801069ed:	83 ec 0c             	sub    $0xc,%esp
801069f0:	68 a0 53 11 80       	push   $0x801153a0
801069f5:	e8 16 ee ff ff       	call   80105810 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801069fd:	8b 1d 80 53 11 80    	mov    0x80115380,%ebx
  while(ticks - ticks0 < n){
80106a03:	83 c4 10             	add    $0x10,%esp
80106a06:	85 d2                	test   %edx,%edx
80106a08:	75 27                	jne    80106a31 <sys_sleep+0x61>
80106a0a:	eb 54                	jmp    80106a60 <sys_sleep+0x90>
80106a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106a10:	83 ec 08             	sub    $0x8,%esp
80106a13:	68 a0 53 11 80       	push   $0x801153a0
80106a18:	68 80 53 11 80       	push   $0x80115380
80106a1d:	e8 7e e2 ff ff       	call   80104ca0 <sleep>
  while(ticks - ticks0 < n){
80106a22:	a1 80 53 11 80       	mov    0x80115380,%eax
80106a27:	83 c4 10             	add    $0x10,%esp
80106a2a:	29 d8                	sub    %ebx,%eax
80106a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106a2f:	73 2f                	jae    80106a60 <sys_sleep+0x90>
    if(myproc()->killed){
80106a31:	e8 7a d8 ff ff       	call   801042b0 <myproc>
80106a36:	8b 40 24             	mov    0x24(%eax),%eax
80106a39:	85 c0                	test   %eax,%eax
80106a3b:	74 d3                	je     80106a10 <sys_sleep+0x40>
      release(&tickslock);
80106a3d:	83 ec 0c             	sub    $0xc,%esp
80106a40:	68 a0 53 11 80       	push   $0x801153a0
80106a45:	e8 66 ed ff ff       	call   801057b0 <release>
  }
  release(&tickslock);
  return 0;
}
80106a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106a4d:	83 c4 10             	add    $0x10,%esp
80106a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a55:	c9                   	leave  
80106a56:	c3                   	ret    
80106a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106a60:	83 ec 0c             	sub    $0xc,%esp
80106a63:	68 a0 53 11 80       	push   $0x801153a0
80106a68:	e8 43 ed ff ff       	call   801057b0 <release>
  return 0;
80106a6d:	83 c4 10             	add    $0x10,%esp
80106a70:	31 c0                	xor    %eax,%eax
}
80106a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a75:	c9                   	leave  
80106a76:	c3                   	ret    
    return -1;
80106a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7c:	eb f4                	jmp    80106a72 <sys_sleep+0xa2>
80106a7e:	66 90                	xchg   %ax,%ax

80106a80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	53                   	push   %ebx
80106a84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106a87:	68 a0 53 11 80       	push   $0x801153a0
80106a8c:	e8 7f ed ff ff       	call   80105810 <acquire>
  xticks = ticks;
80106a91:	8b 1d 80 53 11 80    	mov    0x80115380,%ebx
  release(&tickslock);
80106a97:	c7 04 24 a0 53 11 80 	movl   $0x801153a0,(%esp)
80106a9e:	e8 0d ed ff ff       	call   801057b0 <release>
  return xticks;
}
80106aa3:	89 d8                	mov    %ebx,%eax
80106aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106aa8:	c9                   	leave  
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ab0 <sys_thread_create>:

int sys_thread_create(void){
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	83 ec 1c             	sub    $0x1c,%esp
  void (*fcn)(void*);
  void* arg;
  void* stack;
  argptr(0,(void*) &fcn, sizeof(void(*)(void *)));
80106ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ab9:	6a 04                	push   $0x4
80106abb:	50                   	push   %eax
80106abc:	6a 00                	push   $0x0
80106abe:	e8 1d f1 ff ff       	call   80105be0 <argptr>
  argptr(1, (void*) &arg, sizeof(void*));
80106ac3:	83 c4 0c             	add    $0xc,%esp
80106ac6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ac9:	6a 04                	push   $0x4
80106acb:	50                   	push   %eax
80106acc:	6a 01                	push   $0x1
80106ace:	e8 0d f1 ff ff       	call   80105be0 <argptr>
  argptr(2, (void*) &stack, sizeof(void *));
80106ad3:	83 c4 0c             	add    $0xc,%esp
80106ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ad9:	6a 04                	push   $0x4
80106adb:	50                   	push   %eax
80106adc:	6a 02                	push   $0x2
80106ade:	e8 fd f0 ff ff       	call   80105be0 <argptr>
  return thread_create(fcn,arg,stack);
80106ae3:	83 c4 0c             	add    $0xc,%esp
80106ae6:	ff 75 f4             	push   -0xc(%ebp)
80106ae9:	ff 75 f0             	push   -0x10(%ebp)
80106aec:	ff 75 ec             	push   -0x14(%ebp)
80106aef:	e8 2c e4 ff ff       	call   80104f20 <thread_create>
}
80106af4:	c9                   	leave  
80106af5:	c3                   	ret    
80106af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afd:	8d 76 00             	lea    0x0(%esi),%esi

80106b00 <sys_thread_join>:

int sys_thread_join(void){
  return thread_join();
80106b00:	e9 4b e5 ff ff       	jmp    80105050 <thread_join>
80106b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b10 <sys_thread_exit>:
}


int sys_thread_exit(void){
  return thread_exit();
80106b10:	e9 5b e6 ff ff       	jmp    80105170 <thread_exit>
80106b15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <sys_getNumProc>:
}

int sys_getNumProc(void){
  return getNumProc();
80106b20:	e9 3b e7 ff ff       	jmp    80105260 <getNumProc>
80106b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <sys_getMaxPid>:
}

int sys_getMaxPid(void){
  return getMaxPid();
80106b30:	e9 7b e7 ff ff       	jmp    801052b0 <getMaxPid>
80106b35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b40 <sys_set_burst_time>:
int sys_getBurstTime(void){
  struct proc *p = myproc();
  return p->burstTime;
}*/

int sys_set_burst_time(void){
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	83 ec 1c             	sub    $0x1c,%esp
  int burst_time;
  argptr(0,(void *)&burst_time, sizeof(burst_time));
80106b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b49:	6a 04                	push   $0x4
80106b4b:	50                   	push   %eax
80106b4c:	6a 00                	push   $0x0
80106b4e:	e8 8d f0 ff ff       	call   80105be0 <argptr>

  return set_burst_timeAssist(burst_time);
80106b53:	58                   	pop    %eax
80106b54:	ff 75 f4             	push   -0xc(%ebp)
80106b57:	e8 a4 e7 ff ff       	call   80105300 <set_burst_timeAssist>
}
80106b5c:	c9                   	leave  
80106b5d:	c3                   	ret    
80106b5e:	66 90                	xchg   %ax,%ax

80106b60 <sys_get_burst_time>:

int sys_get_burst_time(void){
  return get_burst_timeAssist();
80106b60:	e9 db e7 ff ff       	jmp    80105340 <get_burst_timeAssist>
80106b65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b70 <sys_getProcInfo>:
}


int sys_getProcInfo(void){
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	83 ec 2c             	sub    $0x2c,%esp
  int pid;
  struct processInfo *info;
  argptr(0,(void *) &pid,sizeof(pid));
80106b76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b79:	6a 04                	push   $0x4
80106b7b:	50                   	push   %eax
80106b7c:	6a 00                	push   $0x0
80106b7e:	e8 5d f0 ff ff       	call   80105be0 <argptr>
  argptr(1,(void *) &info,sizeof(info));
80106b83:	83 c4 0c             	add    $0xc,%esp
80106b86:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b89:	6a 04                	push   $0x4
80106b8b:	50                   	push   %eax
80106b8c:	6a 01                	push   $0x1
80106b8e:	e8 4d f0 ff ff       	call   80105be0 <argptr>
  struct processInfo tempInfo = getProcInfoHelp(pid);
80106b93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b96:	5a                   	pop    %edx
80106b97:	59                   	pop    %ecx
80106b98:	ff 75 e4             	push   -0x1c(%ebp)
80106b9b:	50                   	push   %eax
80106b9c:	e8 cf e7 ff ff       	call   80105370 <getProcInfoHelp>
80106ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  if(tempInfo.ppid==-1)
80106ba4:	83 c4 0c             	add    $0xc,%esp
80106ba7:	83 f8 ff             	cmp    $0xffffffff,%eax
80106baa:	74 16                	je     80106bc2 <sys_getProcInfo+0x52>
    return -1;
  info->ppid = tempInfo.ppid;
80106bac:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106baf:	89 02                	mov    %eax,(%edx)
  info->psize = tempInfo.psize;
80106bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bb7:	89 50 04             	mov    %edx,0x4(%eax)
  info->numberContextSwitches = tempInfo.numberContextSwitches;
80106bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bbd:	89 50 08             	mov    %edx,0x8(%eax)
  return 0;  
80106bc0:	31 c0                	xor    %eax,%eax
}
80106bc2:	c9                   	leave  
80106bc3:	c3                   	ret    
80106bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bcf:	90                   	nop

80106bd0 <sys_draw>:

int 
sys_draw(void){
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	83 ec 2c             	sub    $0x2c,%esp
  void* buf;
  uint size;
  argptr(0,(void*)&buf,sizeof(buf));
80106bd6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106bd9:	6a 04                	push   $0x4
80106bdb:	50                   	push   %eax
80106bdc:	6a 00                	push   $0x0
80106bde:	e8 fd ef ff ff       	call   80105be0 <argptr>
  argptr(1,(void*)&size,sizeof(size));
80106be3:	83 c4 0c             	add    $0xc,%esp
80106be6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106be9:	6a 04                	push   $0x4
80106beb:	50                   	push   %eax
80106bec:	6a 01                	push   $0x1
80106bee:	e8 ed ef ff ff       	call   80105be0 <argptr>
  char figure[] = "\nGroup M10\n";
  if(sizeof(figure)>size)return -1;
80106bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bf6:	83 c4 10             	add    $0x10,%esp
  char figure[] = "\nGroup M10\n";
80106bf9:	c7 45 ec 0a 47 72 6f 	movl   $0x6f72470a,-0x14(%ebp)
80106c00:	c7 45 f0 75 70 20 4d 	movl   $0x4d207075,-0x10(%ebp)
80106c07:	c7 45 f4 31 30 0a 00 	movl   $0xa3031,-0xc(%ebp)
  if(sizeof(figure)>size)return -1;
80106c0e:	83 f8 0b             	cmp    $0xb,%eax
80106c11:	76 1d                	jbe    80106c30 <sys_draw+0x60>
  strncpy((char *)buf,figure,size);
80106c13:	83 ec 04             	sub    $0x4,%esp
80106c16:	50                   	push   %eax
80106c17:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c1a:	50                   	push   %eax
80106c1b:	ff 75 e4             	push   -0x1c(%ebp)
80106c1e:	e8 0d ee ff ff       	call   80105a30 <strncpy>
  return sizeof(figure);                
80106c23:	83 c4 10             	add    $0x10,%esp
80106c26:	b8 0c 00 00 00       	mov    $0xc,%eax
}
80106c2b:	c9                   	leave  
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	c9                   	leave  
  if(sizeof(figure)>size)return -1;
80106c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c36:	c3                   	ret    
80106c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3e:	66 90                	xchg   %ax,%ax

80106c40 <sys_getCurrentInfo>:

int
sys_getCurrentInfo(void)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 1c             	sub    $0x1c,%esp
  struct processInfo *info;
  argptr(0,(void *)&info, sizeof(info));
80106c46:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c49:	6a 04                	push   $0x4
80106c4b:	50                   	push   %eax
80106c4c:	6a 00                	push   $0x0
80106c4e:	e8 8d ef ff ff       	call   80105be0 <argptr>

  struct processInfo temporaryInfo = getCurrentInfoAssist();
80106c53:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c56:	89 04 24             	mov    %eax,(%esp)
80106c59:	e8 b2 e7 ff ff       	call   80105410 <getCurrentInfoAssist>
80106c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax

  if(temporaryInfo.ppid == -1)return -1;
80106c61:	83 c4 0c             	add    $0xc,%esp
80106c64:	83 f8 ff             	cmp    $0xffffffff,%eax
80106c67:	74 16                	je     80106c7f <sys_getCurrentInfo+0x3f>

  info->ppid = temporaryInfo.ppid;
80106c69:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106c6c:	89 02                	mov    %eax,(%edx)
  info->psize = temporaryInfo.psize;
80106c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c74:	89 50 04             	mov    %edx,0x4(%eax)
  info->numberContextSwitches = temporaryInfo.numberContextSwitches;
80106c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c7a:	89 50 08             	mov    %edx,0x8(%eax)
  return 0;
80106c7d:	31 c0                	xor    %eax,%eax
}
80106c7f:	c9                   	leave  
80106c80:	c3                   	ret    
80106c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8f:	90                   	nop

80106c90 <sys_getCurrentPID>:

int sys_getCurrentPID(void){
  return getCurrentPIDAssist();
80106c90:	e9 2b e8 ff ff       	jmp    801054c0 <getCurrentPIDAssist>

80106c95 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c95:	1e                   	push   %ds
  pushl %es
80106c96:	06                   	push   %es
  pushl %fs
80106c97:	0f a0                	push   %fs
  pushl %gs
80106c99:	0f a8                	push   %gs
  pushal
80106c9b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c9c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106ca0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106ca2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106ca4:	54                   	push   %esp
  call trap
80106ca5:	e8 c6 00 00 00       	call   80106d70 <trap>
  addl $4, %esp
80106caa:	83 c4 04             	add    $0x4,%esp

80106cad <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106cad:	61                   	popa   
  popl %gs
80106cae:	0f a9                	pop    %gs
  popl %fs
80106cb0:	0f a1                	pop    %fs
  popl %es
80106cb2:	07                   	pop    %es
  popl %ds
80106cb3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106cb4:	83 c4 08             	add    $0x8,%esp
  iret
80106cb7:	cf                   	iret   
80106cb8:	66 90                	xchg   %ax,%ax
80106cba:	66 90                	xchg   %ax,%ax
80106cbc:	66 90                	xchg   %ax,%ax
80106cbe:	66 90                	xchg   %ax,%ax

80106cc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106cc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106cc1:	31 c0                	xor    %eax,%eax
{
80106cc3:	89 e5                	mov    %esp,%ebp
80106cc5:	83 ec 08             	sub    $0x8,%esp
80106cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106cd0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106cd7:	c7 04 c5 e2 53 11 80 	movl   $0x8e000008,-0x7feeac1e(,%eax,8)
80106cde:	08 00 00 8e 
80106ce2:	66 89 14 c5 e0 53 11 	mov    %dx,-0x7feeac20(,%eax,8)
80106ce9:	80 
80106cea:	c1 ea 10             	shr    $0x10,%edx
80106ced:	66 89 14 c5 e6 53 11 	mov    %dx,-0x7feeac1a(,%eax,8)
80106cf4:	80 
  for(i = 0; i < 256; i++)
80106cf5:	83 c0 01             	add    $0x1,%eax
80106cf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106cfd:	75 d1                	jne    80106cd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106cff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d02:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80106d07:	c7 05 e2 55 11 80 08 	movl   $0xef000008,0x801155e2
80106d0e:	00 00 ef 
  initlock(&tickslock, "time");
80106d11:	68 e5 8d 10 80       	push   $0x80108de5
80106d16:	68 a0 53 11 80       	push   $0x801153a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d1b:	66 a3 e0 55 11 80    	mov    %ax,0x801155e0
80106d21:	c1 e8 10             	shr    $0x10,%eax
80106d24:	66 a3 e6 55 11 80    	mov    %ax,0x801155e6
  initlock(&tickslock, "time");
80106d2a:	e8 11 e9 ff ff       	call   80105640 <initlock>
}
80106d2f:	83 c4 10             	add    $0x10,%esp
80106d32:	c9                   	leave  
80106d33:	c3                   	ret    
80106d34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d3f:	90                   	nop

80106d40 <idtinit>:

void
idtinit(void)
{
80106d40:	55                   	push   %ebp
  pd[0] = size-1;
80106d41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106d46:	89 e5                	mov    %esp,%ebp
80106d48:	83 ec 10             	sub    $0x10,%esp
80106d4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d4f:	b8 e0 53 11 80       	mov    $0x801153e0,%eax
80106d54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d58:	c1 e8 10             	shr    $0x10,%eax
80106d5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106d5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106d65:	c9                   	leave  
80106d66:	c3                   	ret    
80106d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6e:	66 90                	xchg   %ax,%ax

80106d70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106d7c:	8b 43 30             	mov    0x30(%ebx),%eax
80106d7f:	83 f8 40             	cmp    $0x40,%eax
80106d82:	0f 84 50 01 00 00    	je     80106ed8 <trap+0x168>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106d88:	83 e8 20             	sub    $0x20,%eax
80106d8b:	83 f8 1f             	cmp    $0x1f,%eax
80106d8e:	0f 87 84 00 00 00    	ja     80106e18 <trap+0xa8>
80106d94:	ff 24 85 48 8e 10 80 	jmp    *-0x7fef71b8(,%eax,4)
80106d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106da0:	e8 9b b4 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106da5:	e8 66 bb ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106daa:	e8 01 d5 ff ff       	call   801042b0 <myproc>
80106daf:	85 c0                	test   %eax,%eax
80106db1:	74 1d                	je     80106dd0 <trap+0x60>
80106db3:	e8 f8 d4 ff ff       	call   801042b0 <myproc>
80106db8:	8b 48 24             	mov    0x24(%eax),%ecx
80106dbb:	85 c9                	test   %ecx,%ecx
80106dbd:	74 11                	je     80106dd0 <trap+0x60>
80106dbf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106dc3:	83 e0 03             	and    $0x3,%eax
80106dc6:	66 83 f8 03          	cmp    $0x3,%ax
80106dca:	0f 84 d0 01 00 00    	je     80106fa0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106dd0:	e8 db d4 ff ff       	call   801042b0 <myproc>
80106dd5:	85 c0                	test   %eax,%eax
80106dd7:	74 0b                	je     80106de4 <trap+0x74>
80106dd9:	e8 d2 d4 ff ff       	call   801042b0 <myproc>
80106dde:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106de2:	74 6c                	je     80106e50 <trap+0xe0>
        new_yield();	
  }
  

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106de4:	e8 c7 d4 ff ff       	call   801042b0 <myproc>
80106de9:	85 c0                	test   %eax,%eax
80106deb:	74 1d                	je     80106e0a <trap+0x9a>
80106ded:	e8 be d4 ff ff       	call   801042b0 <myproc>
80106df2:	8b 40 24             	mov    0x24(%eax),%eax
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 11                	je     80106e0a <trap+0x9a>
80106df9:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106dfd:	83 e0 03             	and    $0x3,%eax
80106e00:	66 83 f8 03          	cmp    $0x3,%ax
80106e04:	0f 84 fb 00 00 00    	je     80106f05 <trap+0x195>
    exit();
}
80106e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e0d:	5b                   	pop    %ebx
80106e0e:	5e                   	pop    %esi
80106e0f:	5f                   	pop    %edi
80106e10:	5d                   	pop    %ebp
80106e11:	c3                   	ret    
80106e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106e18:	e8 93 d4 ff ff       	call   801042b0 <myproc>
80106e1d:	85 c0                	test   %eax,%eax
80106e1f:	0f 84 c1 01 00 00    	je     80106fe6 <trap+0x276>
80106e25:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106e29:	0f 84 b7 01 00 00    	je     80106fe6 <trap+0x276>
    myproc()->killed = 1;
80106e2f:	e8 7c d4 ff ff       	call   801042b0 <myproc>
80106e34:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e3b:	e8 70 d4 ff ff       	call   801042b0 <myproc>
80106e40:	85 c0                	test   %eax,%eax
80106e42:	0f 85 6b ff ff ff    	jne    80106db3 <trap+0x43>
80106e48:	eb 86                	jmp    80106dd0 <trap+0x60>
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106e50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106e54:	75 8e                	jne    80106de4 <trap+0x74>
     (myproc()->run_time)++;
80106e56:	e8 55 d4 ff ff       	call   801042b0 <myproc>
80106e5b:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
     if(myproc()->burst_time != 0){
80106e62:	e8 49 d4 ff ff       	call   801042b0 <myproc>
80106e67:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80106e6d:	85 d2                	test   %edx,%edx
80106e6f:	0f 85 4b 01 00 00    	jne    80106fc0 <trap+0x250>
     if((myproc()->run_time)%quant == 0)
80106e75:	e8 36 d4 ff ff       	call   801042b0 <myproc>
80106e7a:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106e80:	99                   	cltd   
80106e81:	f7 3d 08 b0 10 80    	idivl  0x8010b008
80106e87:	85 d2                	test   %edx,%edx
80106e89:	0f 85 55 ff ff ff    	jne    80106de4 <trap+0x74>
        new_yield();	
80106e8f:	e8 5c dd ff ff       	call   80104bf0 <new_yield>
80106e94:	e9 4b ff ff ff       	jmp    80106de4 <trap+0x74>
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ea0:	8b 7b 38             	mov    0x38(%ebx),%edi
80106ea3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106ea7:	e8 e4 d3 ff ff       	call   80104290 <cpuid>
80106eac:	57                   	push   %edi
80106ead:	56                   	push   %esi
80106eae:	50                   	push   %eax
80106eaf:	68 f0 8d 10 80       	push   $0x80108df0
80106eb4:	e8 e7 97 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106eb9:	e8 52 ba ff ff       	call   80102910 <lapiceoi>
    break;
80106ebe:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ec1:	e8 ea d3 ff ff       	call   801042b0 <myproc>
80106ec6:	85 c0                	test   %eax,%eax
80106ec8:	0f 85 e5 fe ff ff    	jne    80106db3 <trap+0x43>
80106ece:	e9 fd fe ff ff       	jmp    80106dd0 <trap+0x60>
80106ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ed7:	90                   	nop
    if(myproc()->killed)
80106ed8:	e8 d3 d3 ff ff       	call   801042b0 <myproc>
80106edd:	8b 70 24             	mov    0x24(%eax),%esi
80106ee0:	85 f6                	test   %esi,%esi
80106ee2:	0f 85 c8 00 00 00    	jne    80106fb0 <trap+0x240>
    myproc()->tf = tf;
80106ee8:	e8 c3 d3 ff ff       	call   801042b0 <myproc>
80106eed:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106ef0:	e8 db ed ff ff       	call   80105cd0 <syscall>
    if(myproc()->killed)
80106ef5:	e8 b6 d3 ff ff       	call   801042b0 <myproc>
80106efa:	8b 58 24             	mov    0x24(%eax),%ebx
80106efd:	85 db                	test   %ebx,%ebx
80106eff:	0f 84 05 ff ff ff    	je     80106e0a <trap+0x9a>
}
80106f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f08:	5b                   	pop    %ebx
80106f09:	5e                   	pop    %esi
80106f0a:	5f                   	pop    %edi
80106f0b:	5d                   	pop    %ebp
      exit();
80106f0c:	e9 df d9 ff ff       	jmp    801048f0 <exit>
80106f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106f18:	e8 73 02 00 00       	call   80107190 <uartintr>
    lapiceoi();
80106f1d:	e8 ee b9 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f22:	e8 89 d3 ff ff       	call   801042b0 <myproc>
80106f27:	85 c0                	test   %eax,%eax
80106f29:	0f 85 84 fe ff ff    	jne    80106db3 <trap+0x43>
80106f2f:	e9 9c fe ff ff       	jmp    80106dd0 <trap+0x60>
80106f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106f38:	e8 93 b8 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106f3d:	e8 ce b9 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f42:	e8 69 d3 ff ff       	call   801042b0 <myproc>
80106f47:	85 c0                	test   %eax,%eax
80106f49:	0f 85 64 fe ff ff    	jne    80106db3 <trap+0x43>
80106f4f:	e9 7c fe ff ff       	jmp    80106dd0 <trap+0x60>
80106f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106f58:	e8 33 d3 ff ff       	call   80104290 <cpuid>
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	0f 85 40 fe ff ff    	jne    80106da5 <trap+0x35>
      acquire(&tickslock);
80106f65:	83 ec 0c             	sub    $0xc,%esp
80106f68:	68 a0 53 11 80       	push   $0x801153a0
80106f6d:	e8 9e e8 ff ff       	call   80105810 <acquire>
      wakeup(&ticks);
80106f72:	c7 04 24 80 53 11 80 	movl   $0x80115380,(%esp)
      ticks++;
80106f79:	83 05 80 53 11 80 01 	addl   $0x1,0x80115380
      wakeup(&ticks);
80106f80:	e8 db dd ff ff       	call   80104d60 <wakeup>
      release(&tickslock);
80106f85:	c7 04 24 a0 53 11 80 	movl   $0x801153a0,(%esp)
80106f8c:	e8 1f e8 ff ff       	call   801057b0 <release>
80106f91:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106f94:	e9 0c fe ff ff       	jmp    80106da5 <trap+0x35>
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106fa0:	e8 4b d9 ff ff       	call   801048f0 <exit>
80106fa5:	e9 26 fe ff ff       	jmp    80106dd0 <trap+0x60>
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106fb0:	e8 3b d9 ff ff       	call   801048f0 <exit>
80106fb5:	e9 2e ff ff ff       	jmp    80106ee8 <trap+0x178>
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     	if(myproc()->burst_time == myproc()->run_time)
80106fc0:	e8 eb d2 ff ff       	call   801042b0 <myproc>
80106fc5:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
80106fcb:	e8 e0 d2 ff ff       	call   801042b0 <myproc>
80106fd0:	3b b0 88 00 00 00    	cmp    0x88(%eax),%esi
80106fd6:	0f 85 99 fe ff ff    	jne    80106e75 <trap+0x105>
        	exit();
80106fdc:	e8 0f d9 ff ff       	call   801048f0 <exit>
80106fe1:	e9 8f fe ff ff       	jmp    80106e75 <trap+0x105>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106fe6:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106fe9:	8b 73 38             	mov    0x38(%ebx),%esi
80106fec:	e8 9f d2 ff ff       	call   80104290 <cpuid>
80106ff1:	83 ec 0c             	sub    $0xc,%esp
80106ff4:	57                   	push   %edi
80106ff5:	56                   	push   %esi
80106ff6:	50                   	push   %eax
80106ff7:	ff 73 30             	push   0x30(%ebx)
80106ffa:	68 14 8e 10 80       	push   $0x80108e14
80106fff:	e8 9c 96 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80107004:	83 c4 14             	add    $0x14,%esp
80107007:	68 ea 8d 10 80       	push   $0x80108dea
8010700c:	e8 6f 93 ff ff       	call   80100380 <panic>
80107011:	66 90                	xchg   %ax,%ax
80107013:	66 90                	xchg   %ax,%ax
80107015:	66 90                	xchg   %ax,%ax
80107017:	66 90                	xchg   %ax,%ax
80107019:	66 90                	xchg   %ax,%ax
8010701b:	66 90                	xchg   %ax,%ax
8010701d:	66 90                	xchg   %ax,%ax
8010701f:	90                   	nop

80107020 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107020:	a1 e0 5b 11 80       	mov    0x80115be0,%eax
80107025:	85 c0                	test   %eax,%eax
80107027:	74 17                	je     80107040 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107029:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010702e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010702f:	a8 01                	test   $0x1,%al
80107031:	74 0d                	je     80107040 <uartgetc+0x20>
80107033:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107038:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107039:	0f b6 c0             	movzbl %al,%eax
8010703c:	c3                   	ret    
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107045:	c3                   	ret    
80107046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704d:	8d 76 00             	lea    0x0(%esi),%esi

80107050 <uartinit>:
{
80107050:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107051:	31 c9                	xor    %ecx,%ecx
80107053:	89 c8                	mov    %ecx,%eax
80107055:	89 e5                	mov    %esp,%ebp
80107057:	57                   	push   %edi
80107058:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010705d:	56                   	push   %esi
8010705e:	89 fa                	mov    %edi,%edx
80107060:	53                   	push   %ebx
80107061:	83 ec 1c             	sub    $0x1c,%esp
80107064:	ee                   	out    %al,(%dx)
80107065:	be fb 03 00 00       	mov    $0x3fb,%esi
8010706a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010706f:	89 f2                	mov    %esi,%edx
80107071:	ee                   	out    %al,(%dx)
80107072:	b8 0c 00 00 00       	mov    $0xc,%eax
80107077:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010707c:	ee                   	out    %al,(%dx)
8010707d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107082:	89 c8                	mov    %ecx,%eax
80107084:	89 da                	mov    %ebx,%edx
80107086:	ee                   	out    %al,(%dx)
80107087:	b8 03 00 00 00       	mov    $0x3,%eax
8010708c:	89 f2                	mov    %esi,%edx
8010708e:	ee                   	out    %al,(%dx)
8010708f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107094:	89 c8                	mov    %ecx,%eax
80107096:	ee                   	out    %al,(%dx)
80107097:	b8 01 00 00 00       	mov    $0x1,%eax
8010709c:	89 da                	mov    %ebx,%edx
8010709e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010709f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801070a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801070a5:	3c ff                	cmp    $0xff,%al
801070a7:	74 78                	je     80107121 <uartinit+0xd1>
  uart = 1;
801070a9:	c7 05 e0 5b 11 80 01 	movl   $0x1,0x80115be0
801070b0:	00 00 00 
801070b3:	89 fa                	mov    %edi,%edx
801070b5:	ec                   	in     (%dx),%al
801070b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070bb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801070bc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801070bf:	bf c8 8e 10 80       	mov    $0x80108ec8,%edi
801070c4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801070c9:	6a 00                	push   $0x0
801070cb:	6a 04                	push   $0x4
801070cd:	e8 ae b3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801070d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801070d6:	83 c4 10             	add    $0x10,%esp
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801070e0:	a1 e0 5b 11 80       	mov    0x80115be0,%eax
801070e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801070ea:	85 c0                	test   %eax,%eax
801070ec:	75 14                	jne    80107102 <uartinit+0xb2>
801070ee:	eb 23                	jmp    80107113 <uartinit+0xc3>
    microdelay(10);
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	6a 0a                	push   $0xa
801070f5:	e8 36 b8 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070fa:	83 c4 10             	add    $0x10,%esp
801070fd:	83 eb 01             	sub    $0x1,%ebx
80107100:	74 07                	je     80107109 <uartinit+0xb9>
80107102:	89 f2                	mov    %esi,%edx
80107104:	ec                   	in     (%dx),%al
80107105:	a8 20                	test   $0x20,%al
80107107:	74 e7                	je     801070f0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107109:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010710d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107112:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107113:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107117:	83 c7 01             	add    $0x1,%edi
8010711a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010711d:	84 c0                	test   %al,%al
8010711f:	75 bf                	jne    801070e0 <uartinit+0x90>
}
80107121:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107124:	5b                   	pop    %ebx
80107125:	5e                   	pop    %esi
80107126:	5f                   	pop    %edi
80107127:	5d                   	pop    %ebp
80107128:	c3                   	ret    
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107130 <uartputc>:
  if(!uart)
80107130:	a1 e0 5b 11 80       	mov    0x80115be0,%eax
80107135:	85 c0                	test   %eax,%eax
80107137:	74 47                	je     80107180 <uartputc+0x50>
{
80107139:	55                   	push   %ebp
8010713a:	89 e5                	mov    %esp,%ebp
8010713c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010713d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107142:	53                   	push   %ebx
80107143:	bb 80 00 00 00       	mov    $0x80,%ebx
80107148:	eb 18                	jmp    80107162 <uartputc+0x32>
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	6a 0a                	push   $0xa
80107155:	e8 d6 b7 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010715a:	83 c4 10             	add    $0x10,%esp
8010715d:	83 eb 01             	sub    $0x1,%ebx
80107160:	74 07                	je     80107169 <uartputc+0x39>
80107162:	89 f2                	mov    %esi,%edx
80107164:	ec                   	in     (%dx),%al
80107165:	a8 20                	test   $0x20,%al
80107167:	74 e7                	je     80107150 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107169:	8b 45 08             	mov    0x8(%ebp),%eax
8010716c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107171:	ee                   	out    %al,(%dx)
}
80107172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107175:	5b                   	pop    %ebx
80107176:	5e                   	pop    %esi
80107177:	5d                   	pop    %ebp
80107178:	c3                   	ret    
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107180:	c3                   	ret    
80107181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718f:	90                   	nop

80107190 <uartintr>:

void
uartintr(void)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107196:	68 20 70 10 80       	push   $0x80107020
8010719b:	e8 e0 96 ff ff       	call   80100880 <consoleintr>
}
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	c9                   	leave  
801071a4:	c3                   	ret    

801071a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $0
801071a7:	6a 00                	push   $0x0
  jmp alltraps
801071a9:	e9 e7 fa ff ff       	jmp    80106c95 <alltraps>

801071ae <vector1>:
.globl vector1
vector1:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $1
801071b0:	6a 01                	push   $0x1
  jmp alltraps
801071b2:	e9 de fa ff ff       	jmp    80106c95 <alltraps>

801071b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $2
801071b9:	6a 02                	push   $0x2
  jmp alltraps
801071bb:	e9 d5 fa ff ff       	jmp    80106c95 <alltraps>

801071c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $3
801071c2:	6a 03                	push   $0x3
  jmp alltraps
801071c4:	e9 cc fa ff ff       	jmp    80106c95 <alltraps>

801071c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $4
801071cb:	6a 04                	push   $0x4
  jmp alltraps
801071cd:	e9 c3 fa ff ff       	jmp    80106c95 <alltraps>

801071d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $5
801071d4:	6a 05                	push   $0x5
  jmp alltraps
801071d6:	e9 ba fa ff ff       	jmp    80106c95 <alltraps>

801071db <vector6>:
.globl vector6
vector6:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $6
801071dd:	6a 06                	push   $0x6
  jmp alltraps
801071df:	e9 b1 fa ff ff       	jmp    80106c95 <alltraps>

801071e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $7
801071e6:	6a 07                	push   $0x7
  jmp alltraps
801071e8:	e9 a8 fa ff ff       	jmp    80106c95 <alltraps>

801071ed <vector8>:
.globl vector8
vector8:
  pushl $8
801071ed:	6a 08                	push   $0x8
  jmp alltraps
801071ef:	e9 a1 fa ff ff       	jmp    80106c95 <alltraps>

801071f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $9
801071f6:	6a 09                	push   $0x9
  jmp alltraps
801071f8:	e9 98 fa ff ff       	jmp    80106c95 <alltraps>

801071fd <vector10>:
.globl vector10
vector10:
  pushl $10
801071fd:	6a 0a                	push   $0xa
  jmp alltraps
801071ff:	e9 91 fa ff ff       	jmp    80106c95 <alltraps>

80107204 <vector11>:
.globl vector11
vector11:
  pushl $11
80107204:	6a 0b                	push   $0xb
  jmp alltraps
80107206:	e9 8a fa ff ff       	jmp    80106c95 <alltraps>

8010720b <vector12>:
.globl vector12
vector12:
  pushl $12
8010720b:	6a 0c                	push   $0xc
  jmp alltraps
8010720d:	e9 83 fa ff ff       	jmp    80106c95 <alltraps>

80107212 <vector13>:
.globl vector13
vector13:
  pushl $13
80107212:	6a 0d                	push   $0xd
  jmp alltraps
80107214:	e9 7c fa ff ff       	jmp    80106c95 <alltraps>

80107219 <vector14>:
.globl vector14
vector14:
  pushl $14
80107219:	6a 0e                	push   $0xe
  jmp alltraps
8010721b:	e9 75 fa ff ff       	jmp    80106c95 <alltraps>

80107220 <vector15>:
.globl vector15
vector15:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $15
80107222:	6a 0f                	push   $0xf
  jmp alltraps
80107224:	e9 6c fa ff ff       	jmp    80106c95 <alltraps>

80107229 <vector16>:
.globl vector16
vector16:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $16
8010722b:	6a 10                	push   $0x10
  jmp alltraps
8010722d:	e9 63 fa ff ff       	jmp    80106c95 <alltraps>

80107232 <vector17>:
.globl vector17
vector17:
  pushl $17
80107232:	6a 11                	push   $0x11
  jmp alltraps
80107234:	e9 5c fa ff ff       	jmp    80106c95 <alltraps>

80107239 <vector18>:
.globl vector18
vector18:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $18
8010723b:	6a 12                	push   $0x12
  jmp alltraps
8010723d:	e9 53 fa ff ff       	jmp    80106c95 <alltraps>

80107242 <vector19>:
.globl vector19
vector19:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $19
80107244:	6a 13                	push   $0x13
  jmp alltraps
80107246:	e9 4a fa ff ff       	jmp    80106c95 <alltraps>

8010724b <vector20>:
.globl vector20
vector20:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $20
8010724d:	6a 14                	push   $0x14
  jmp alltraps
8010724f:	e9 41 fa ff ff       	jmp    80106c95 <alltraps>

80107254 <vector21>:
.globl vector21
vector21:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $21
80107256:	6a 15                	push   $0x15
  jmp alltraps
80107258:	e9 38 fa ff ff       	jmp    80106c95 <alltraps>

8010725d <vector22>:
.globl vector22
vector22:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $22
8010725f:	6a 16                	push   $0x16
  jmp alltraps
80107261:	e9 2f fa ff ff       	jmp    80106c95 <alltraps>

80107266 <vector23>:
.globl vector23
vector23:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $23
80107268:	6a 17                	push   $0x17
  jmp alltraps
8010726a:	e9 26 fa ff ff       	jmp    80106c95 <alltraps>

8010726f <vector24>:
.globl vector24
vector24:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $24
80107271:	6a 18                	push   $0x18
  jmp alltraps
80107273:	e9 1d fa ff ff       	jmp    80106c95 <alltraps>

80107278 <vector25>:
.globl vector25
vector25:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $25
8010727a:	6a 19                	push   $0x19
  jmp alltraps
8010727c:	e9 14 fa ff ff       	jmp    80106c95 <alltraps>

80107281 <vector26>:
.globl vector26
vector26:
  pushl $0
80107281:	6a 00                	push   $0x0
  pushl $26
80107283:	6a 1a                	push   $0x1a
  jmp alltraps
80107285:	e9 0b fa ff ff       	jmp    80106c95 <alltraps>

8010728a <vector27>:
.globl vector27
vector27:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $27
8010728c:	6a 1b                	push   $0x1b
  jmp alltraps
8010728e:	e9 02 fa ff ff       	jmp    80106c95 <alltraps>

80107293 <vector28>:
.globl vector28
vector28:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $28
80107295:	6a 1c                	push   $0x1c
  jmp alltraps
80107297:	e9 f9 f9 ff ff       	jmp    80106c95 <alltraps>

8010729c <vector29>:
.globl vector29
vector29:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $29
8010729e:	6a 1d                	push   $0x1d
  jmp alltraps
801072a0:	e9 f0 f9 ff ff       	jmp    80106c95 <alltraps>

801072a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $30
801072a7:	6a 1e                	push   $0x1e
  jmp alltraps
801072a9:	e9 e7 f9 ff ff       	jmp    80106c95 <alltraps>

801072ae <vector31>:
.globl vector31
vector31:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $31
801072b0:	6a 1f                	push   $0x1f
  jmp alltraps
801072b2:	e9 de f9 ff ff       	jmp    80106c95 <alltraps>

801072b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $32
801072b9:	6a 20                	push   $0x20
  jmp alltraps
801072bb:	e9 d5 f9 ff ff       	jmp    80106c95 <alltraps>

801072c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $33
801072c2:	6a 21                	push   $0x21
  jmp alltraps
801072c4:	e9 cc f9 ff ff       	jmp    80106c95 <alltraps>

801072c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $34
801072cb:	6a 22                	push   $0x22
  jmp alltraps
801072cd:	e9 c3 f9 ff ff       	jmp    80106c95 <alltraps>

801072d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $35
801072d4:	6a 23                	push   $0x23
  jmp alltraps
801072d6:	e9 ba f9 ff ff       	jmp    80106c95 <alltraps>

801072db <vector36>:
.globl vector36
vector36:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $36
801072dd:	6a 24                	push   $0x24
  jmp alltraps
801072df:	e9 b1 f9 ff ff       	jmp    80106c95 <alltraps>

801072e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $37
801072e6:	6a 25                	push   $0x25
  jmp alltraps
801072e8:	e9 a8 f9 ff ff       	jmp    80106c95 <alltraps>

801072ed <vector38>:
.globl vector38
vector38:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $38
801072ef:	6a 26                	push   $0x26
  jmp alltraps
801072f1:	e9 9f f9 ff ff       	jmp    80106c95 <alltraps>

801072f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $39
801072f8:	6a 27                	push   $0x27
  jmp alltraps
801072fa:	e9 96 f9 ff ff       	jmp    80106c95 <alltraps>

801072ff <vector40>:
.globl vector40
vector40:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $40
80107301:	6a 28                	push   $0x28
  jmp alltraps
80107303:	e9 8d f9 ff ff       	jmp    80106c95 <alltraps>

80107308 <vector41>:
.globl vector41
vector41:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $41
8010730a:	6a 29                	push   $0x29
  jmp alltraps
8010730c:	e9 84 f9 ff ff       	jmp    80106c95 <alltraps>

80107311 <vector42>:
.globl vector42
vector42:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $42
80107313:	6a 2a                	push   $0x2a
  jmp alltraps
80107315:	e9 7b f9 ff ff       	jmp    80106c95 <alltraps>

8010731a <vector43>:
.globl vector43
vector43:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $43
8010731c:	6a 2b                	push   $0x2b
  jmp alltraps
8010731e:	e9 72 f9 ff ff       	jmp    80106c95 <alltraps>

80107323 <vector44>:
.globl vector44
vector44:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $44
80107325:	6a 2c                	push   $0x2c
  jmp alltraps
80107327:	e9 69 f9 ff ff       	jmp    80106c95 <alltraps>

8010732c <vector45>:
.globl vector45
vector45:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $45
8010732e:	6a 2d                	push   $0x2d
  jmp alltraps
80107330:	e9 60 f9 ff ff       	jmp    80106c95 <alltraps>

80107335 <vector46>:
.globl vector46
vector46:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $46
80107337:	6a 2e                	push   $0x2e
  jmp alltraps
80107339:	e9 57 f9 ff ff       	jmp    80106c95 <alltraps>

8010733e <vector47>:
.globl vector47
vector47:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $47
80107340:	6a 2f                	push   $0x2f
  jmp alltraps
80107342:	e9 4e f9 ff ff       	jmp    80106c95 <alltraps>

80107347 <vector48>:
.globl vector48
vector48:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $48
80107349:	6a 30                	push   $0x30
  jmp alltraps
8010734b:	e9 45 f9 ff ff       	jmp    80106c95 <alltraps>

80107350 <vector49>:
.globl vector49
vector49:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $49
80107352:	6a 31                	push   $0x31
  jmp alltraps
80107354:	e9 3c f9 ff ff       	jmp    80106c95 <alltraps>

80107359 <vector50>:
.globl vector50
vector50:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $50
8010735b:	6a 32                	push   $0x32
  jmp alltraps
8010735d:	e9 33 f9 ff ff       	jmp    80106c95 <alltraps>

80107362 <vector51>:
.globl vector51
vector51:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $51
80107364:	6a 33                	push   $0x33
  jmp alltraps
80107366:	e9 2a f9 ff ff       	jmp    80106c95 <alltraps>

8010736b <vector52>:
.globl vector52
vector52:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $52
8010736d:	6a 34                	push   $0x34
  jmp alltraps
8010736f:	e9 21 f9 ff ff       	jmp    80106c95 <alltraps>

80107374 <vector53>:
.globl vector53
vector53:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $53
80107376:	6a 35                	push   $0x35
  jmp alltraps
80107378:	e9 18 f9 ff ff       	jmp    80106c95 <alltraps>

8010737d <vector54>:
.globl vector54
vector54:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $54
8010737f:	6a 36                	push   $0x36
  jmp alltraps
80107381:	e9 0f f9 ff ff       	jmp    80106c95 <alltraps>

80107386 <vector55>:
.globl vector55
vector55:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $55
80107388:	6a 37                	push   $0x37
  jmp alltraps
8010738a:	e9 06 f9 ff ff       	jmp    80106c95 <alltraps>

8010738f <vector56>:
.globl vector56
vector56:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $56
80107391:	6a 38                	push   $0x38
  jmp alltraps
80107393:	e9 fd f8 ff ff       	jmp    80106c95 <alltraps>

80107398 <vector57>:
.globl vector57
vector57:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $57
8010739a:	6a 39                	push   $0x39
  jmp alltraps
8010739c:	e9 f4 f8 ff ff       	jmp    80106c95 <alltraps>

801073a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $58
801073a3:	6a 3a                	push   $0x3a
  jmp alltraps
801073a5:	e9 eb f8 ff ff       	jmp    80106c95 <alltraps>

801073aa <vector59>:
.globl vector59
vector59:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $59
801073ac:	6a 3b                	push   $0x3b
  jmp alltraps
801073ae:	e9 e2 f8 ff ff       	jmp    80106c95 <alltraps>

801073b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $60
801073b5:	6a 3c                	push   $0x3c
  jmp alltraps
801073b7:	e9 d9 f8 ff ff       	jmp    80106c95 <alltraps>

801073bc <vector61>:
.globl vector61
vector61:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $61
801073be:	6a 3d                	push   $0x3d
  jmp alltraps
801073c0:	e9 d0 f8 ff ff       	jmp    80106c95 <alltraps>

801073c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $62
801073c7:	6a 3e                	push   $0x3e
  jmp alltraps
801073c9:	e9 c7 f8 ff ff       	jmp    80106c95 <alltraps>

801073ce <vector63>:
.globl vector63
vector63:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $63
801073d0:	6a 3f                	push   $0x3f
  jmp alltraps
801073d2:	e9 be f8 ff ff       	jmp    80106c95 <alltraps>

801073d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $64
801073d9:	6a 40                	push   $0x40
  jmp alltraps
801073db:	e9 b5 f8 ff ff       	jmp    80106c95 <alltraps>

801073e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $65
801073e2:	6a 41                	push   $0x41
  jmp alltraps
801073e4:	e9 ac f8 ff ff       	jmp    80106c95 <alltraps>

801073e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $66
801073eb:	6a 42                	push   $0x42
  jmp alltraps
801073ed:	e9 a3 f8 ff ff       	jmp    80106c95 <alltraps>

801073f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $67
801073f4:	6a 43                	push   $0x43
  jmp alltraps
801073f6:	e9 9a f8 ff ff       	jmp    80106c95 <alltraps>

801073fb <vector68>:
.globl vector68
vector68:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $68
801073fd:	6a 44                	push   $0x44
  jmp alltraps
801073ff:	e9 91 f8 ff ff       	jmp    80106c95 <alltraps>

80107404 <vector69>:
.globl vector69
vector69:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $69
80107406:	6a 45                	push   $0x45
  jmp alltraps
80107408:	e9 88 f8 ff ff       	jmp    80106c95 <alltraps>

8010740d <vector70>:
.globl vector70
vector70:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $70
8010740f:	6a 46                	push   $0x46
  jmp alltraps
80107411:	e9 7f f8 ff ff       	jmp    80106c95 <alltraps>

80107416 <vector71>:
.globl vector71
vector71:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $71
80107418:	6a 47                	push   $0x47
  jmp alltraps
8010741a:	e9 76 f8 ff ff       	jmp    80106c95 <alltraps>

8010741f <vector72>:
.globl vector72
vector72:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $72
80107421:	6a 48                	push   $0x48
  jmp alltraps
80107423:	e9 6d f8 ff ff       	jmp    80106c95 <alltraps>

80107428 <vector73>:
.globl vector73
vector73:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $73
8010742a:	6a 49                	push   $0x49
  jmp alltraps
8010742c:	e9 64 f8 ff ff       	jmp    80106c95 <alltraps>

80107431 <vector74>:
.globl vector74
vector74:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $74
80107433:	6a 4a                	push   $0x4a
  jmp alltraps
80107435:	e9 5b f8 ff ff       	jmp    80106c95 <alltraps>

8010743a <vector75>:
.globl vector75
vector75:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $75
8010743c:	6a 4b                	push   $0x4b
  jmp alltraps
8010743e:	e9 52 f8 ff ff       	jmp    80106c95 <alltraps>

80107443 <vector76>:
.globl vector76
vector76:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $76
80107445:	6a 4c                	push   $0x4c
  jmp alltraps
80107447:	e9 49 f8 ff ff       	jmp    80106c95 <alltraps>

8010744c <vector77>:
.globl vector77
vector77:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $77
8010744e:	6a 4d                	push   $0x4d
  jmp alltraps
80107450:	e9 40 f8 ff ff       	jmp    80106c95 <alltraps>

80107455 <vector78>:
.globl vector78
vector78:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $78
80107457:	6a 4e                	push   $0x4e
  jmp alltraps
80107459:	e9 37 f8 ff ff       	jmp    80106c95 <alltraps>

8010745e <vector79>:
.globl vector79
vector79:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $79
80107460:	6a 4f                	push   $0x4f
  jmp alltraps
80107462:	e9 2e f8 ff ff       	jmp    80106c95 <alltraps>

80107467 <vector80>:
.globl vector80
vector80:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $80
80107469:	6a 50                	push   $0x50
  jmp alltraps
8010746b:	e9 25 f8 ff ff       	jmp    80106c95 <alltraps>

80107470 <vector81>:
.globl vector81
vector81:
  pushl $0
80107470:	6a 00                	push   $0x0
  pushl $81
80107472:	6a 51                	push   $0x51
  jmp alltraps
80107474:	e9 1c f8 ff ff       	jmp    80106c95 <alltraps>

80107479 <vector82>:
.globl vector82
vector82:
  pushl $0
80107479:	6a 00                	push   $0x0
  pushl $82
8010747b:	6a 52                	push   $0x52
  jmp alltraps
8010747d:	e9 13 f8 ff ff       	jmp    80106c95 <alltraps>

80107482 <vector83>:
.globl vector83
vector83:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $83
80107484:	6a 53                	push   $0x53
  jmp alltraps
80107486:	e9 0a f8 ff ff       	jmp    80106c95 <alltraps>

8010748b <vector84>:
.globl vector84
vector84:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $84
8010748d:	6a 54                	push   $0x54
  jmp alltraps
8010748f:	e9 01 f8 ff ff       	jmp    80106c95 <alltraps>

80107494 <vector85>:
.globl vector85
vector85:
  pushl $0
80107494:	6a 00                	push   $0x0
  pushl $85
80107496:	6a 55                	push   $0x55
  jmp alltraps
80107498:	e9 f8 f7 ff ff       	jmp    80106c95 <alltraps>

8010749d <vector86>:
.globl vector86
vector86:
  pushl $0
8010749d:	6a 00                	push   $0x0
  pushl $86
8010749f:	6a 56                	push   $0x56
  jmp alltraps
801074a1:	e9 ef f7 ff ff       	jmp    80106c95 <alltraps>

801074a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $87
801074a8:	6a 57                	push   $0x57
  jmp alltraps
801074aa:	e9 e6 f7 ff ff       	jmp    80106c95 <alltraps>

801074af <vector88>:
.globl vector88
vector88:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $88
801074b1:	6a 58                	push   $0x58
  jmp alltraps
801074b3:	e9 dd f7 ff ff       	jmp    80106c95 <alltraps>

801074b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801074b8:	6a 00                	push   $0x0
  pushl $89
801074ba:	6a 59                	push   $0x59
  jmp alltraps
801074bc:	e9 d4 f7 ff ff       	jmp    80106c95 <alltraps>

801074c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801074c1:	6a 00                	push   $0x0
  pushl $90
801074c3:	6a 5a                	push   $0x5a
  jmp alltraps
801074c5:	e9 cb f7 ff ff       	jmp    80106c95 <alltraps>

801074ca <vector91>:
.globl vector91
vector91:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $91
801074cc:	6a 5b                	push   $0x5b
  jmp alltraps
801074ce:	e9 c2 f7 ff ff       	jmp    80106c95 <alltraps>

801074d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $92
801074d5:	6a 5c                	push   $0x5c
  jmp alltraps
801074d7:	e9 b9 f7 ff ff       	jmp    80106c95 <alltraps>

801074dc <vector93>:
.globl vector93
vector93:
  pushl $0
801074dc:	6a 00                	push   $0x0
  pushl $93
801074de:	6a 5d                	push   $0x5d
  jmp alltraps
801074e0:	e9 b0 f7 ff ff       	jmp    80106c95 <alltraps>

801074e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801074e5:	6a 00                	push   $0x0
  pushl $94
801074e7:	6a 5e                	push   $0x5e
  jmp alltraps
801074e9:	e9 a7 f7 ff ff       	jmp    80106c95 <alltraps>

801074ee <vector95>:
.globl vector95
vector95:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $95
801074f0:	6a 5f                	push   $0x5f
  jmp alltraps
801074f2:	e9 9e f7 ff ff       	jmp    80106c95 <alltraps>

801074f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $96
801074f9:	6a 60                	push   $0x60
  jmp alltraps
801074fb:	e9 95 f7 ff ff       	jmp    80106c95 <alltraps>

80107500 <vector97>:
.globl vector97
vector97:
  pushl $0
80107500:	6a 00                	push   $0x0
  pushl $97
80107502:	6a 61                	push   $0x61
  jmp alltraps
80107504:	e9 8c f7 ff ff       	jmp    80106c95 <alltraps>

80107509 <vector98>:
.globl vector98
vector98:
  pushl $0
80107509:	6a 00                	push   $0x0
  pushl $98
8010750b:	6a 62                	push   $0x62
  jmp alltraps
8010750d:	e9 83 f7 ff ff       	jmp    80106c95 <alltraps>

80107512 <vector99>:
.globl vector99
vector99:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $99
80107514:	6a 63                	push   $0x63
  jmp alltraps
80107516:	e9 7a f7 ff ff       	jmp    80106c95 <alltraps>

8010751b <vector100>:
.globl vector100
vector100:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $100
8010751d:	6a 64                	push   $0x64
  jmp alltraps
8010751f:	e9 71 f7 ff ff       	jmp    80106c95 <alltraps>

80107524 <vector101>:
.globl vector101
vector101:
  pushl $0
80107524:	6a 00                	push   $0x0
  pushl $101
80107526:	6a 65                	push   $0x65
  jmp alltraps
80107528:	e9 68 f7 ff ff       	jmp    80106c95 <alltraps>

8010752d <vector102>:
.globl vector102
vector102:
  pushl $0
8010752d:	6a 00                	push   $0x0
  pushl $102
8010752f:	6a 66                	push   $0x66
  jmp alltraps
80107531:	e9 5f f7 ff ff       	jmp    80106c95 <alltraps>

80107536 <vector103>:
.globl vector103
vector103:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $103
80107538:	6a 67                	push   $0x67
  jmp alltraps
8010753a:	e9 56 f7 ff ff       	jmp    80106c95 <alltraps>

8010753f <vector104>:
.globl vector104
vector104:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $104
80107541:	6a 68                	push   $0x68
  jmp alltraps
80107543:	e9 4d f7 ff ff       	jmp    80106c95 <alltraps>

80107548 <vector105>:
.globl vector105
vector105:
  pushl $0
80107548:	6a 00                	push   $0x0
  pushl $105
8010754a:	6a 69                	push   $0x69
  jmp alltraps
8010754c:	e9 44 f7 ff ff       	jmp    80106c95 <alltraps>

80107551 <vector106>:
.globl vector106
vector106:
  pushl $0
80107551:	6a 00                	push   $0x0
  pushl $106
80107553:	6a 6a                	push   $0x6a
  jmp alltraps
80107555:	e9 3b f7 ff ff       	jmp    80106c95 <alltraps>

8010755a <vector107>:
.globl vector107
vector107:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $107
8010755c:	6a 6b                	push   $0x6b
  jmp alltraps
8010755e:	e9 32 f7 ff ff       	jmp    80106c95 <alltraps>

80107563 <vector108>:
.globl vector108
vector108:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $108
80107565:	6a 6c                	push   $0x6c
  jmp alltraps
80107567:	e9 29 f7 ff ff       	jmp    80106c95 <alltraps>

8010756c <vector109>:
.globl vector109
vector109:
  pushl $0
8010756c:	6a 00                	push   $0x0
  pushl $109
8010756e:	6a 6d                	push   $0x6d
  jmp alltraps
80107570:	e9 20 f7 ff ff       	jmp    80106c95 <alltraps>

80107575 <vector110>:
.globl vector110
vector110:
  pushl $0
80107575:	6a 00                	push   $0x0
  pushl $110
80107577:	6a 6e                	push   $0x6e
  jmp alltraps
80107579:	e9 17 f7 ff ff       	jmp    80106c95 <alltraps>

8010757e <vector111>:
.globl vector111
vector111:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $111
80107580:	6a 6f                	push   $0x6f
  jmp alltraps
80107582:	e9 0e f7 ff ff       	jmp    80106c95 <alltraps>

80107587 <vector112>:
.globl vector112
vector112:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $112
80107589:	6a 70                	push   $0x70
  jmp alltraps
8010758b:	e9 05 f7 ff ff       	jmp    80106c95 <alltraps>

80107590 <vector113>:
.globl vector113
vector113:
  pushl $0
80107590:	6a 00                	push   $0x0
  pushl $113
80107592:	6a 71                	push   $0x71
  jmp alltraps
80107594:	e9 fc f6 ff ff       	jmp    80106c95 <alltraps>

80107599 <vector114>:
.globl vector114
vector114:
  pushl $0
80107599:	6a 00                	push   $0x0
  pushl $114
8010759b:	6a 72                	push   $0x72
  jmp alltraps
8010759d:	e9 f3 f6 ff ff       	jmp    80106c95 <alltraps>

801075a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $115
801075a4:	6a 73                	push   $0x73
  jmp alltraps
801075a6:	e9 ea f6 ff ff       	jmp    80106c95 <alltraps>

801075ab <vector116>:
.globl vector116
vector116:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $116
801075ad:	6a 74                	push   $0x74
  jmp alltraps
801075af:	e9 e1 f6 ff ff       	jmp    80106c95 <alltraps>

801075b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801075b4:	6a 00                	push   $0x0
  pushl $117
801075b6:	6a 75                	push   $0x75
  jmp alltraps
801075b8:	e9 d8 f6 ff ff       	jmp    80106c95 <alltraps>

801075bd <vector118>:
.globl vector118
vector118:
  pushl $0
801075bd:	6a 00                	push   $0x0
  pushl $118
801075bf:	6a 76                	push   $0x76
  jmp alltraps
801075c1:	e9 cf f6 ff ff       	jmp    80106c95 <alltraps>

801075c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $119
801075c8:	6a 77                	push   $0x77
  jmp alltraps
801075ca:	e9 c6 f6 ff ff       	jmp    80106c95 <alltraps>

801075cf <vector120>:
.globl vector120
vector120:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $120
801075d1:	6a 78                	push   $0x78
  jmp alltraps
801075d3:	e9 bd f6 ff ff       	jmp    80106c95 <alltraps>

801075d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801075d8:	6a 00                	push   $0x0
  pushl $121
801075da:	6a 79                	push   $0x79
  jmp alltraps
801075dc:	e9 b4 f6 ff ff       	jmp    80106c95 <alltraps>

801075e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801075e1:	6a 00                	push   $0x0
  pushl $122
801075e3:	6a 7a                	push   $0x7a
  jmp alltraps
801075e5:	e9 ab f6 ff ff       	jmp    80106c95 <alltraps>

801075ea <vector123>:
.globl vector123
vector123:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $123
801075ec:	6a 7b                	push   $0x7b
  jmp alltraps
801075ee:	e9 a2 f6 ff ff       	jmp    80106c95 <alltraps>

801075f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $124
801075f5:	6a 7c                	push   $0x7c
  jmp alltraps
801075f7:	e9 99 f6 ff ff       	jmp    80106c95 <alltraps>

801075fc <vector125>:
.globl vector125
vector125:
  pushl $0
801075fc:	6a 00                	push   $0x0
  pushl $125
801075fe:	6a 7d                	push   $0x7d
  jmp alltraps
80107600:	e9 90 f6 ff ff       	jmp    80106c95 <alltraps>

80107605 <vector126>:
.globl vector126
vector126:
  pushl $0
80107605:	6a 00                	push   $0x0
  pushl $126
80107607:	6a 7e                	push   $0x7e
  jmp alltraps
80107609:	e9 87 f6 ff ff       	jmp    80106c95 <alltraps>

8010760e <vector127>:
.globl vector127
vector127:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $127
80107610:	6a 7f                	push   $0x7f
  jmp alltraps
80107612:	e9 7e f6 ff ff       	jmp    80106c95 <alltraps>

80107617 <vector128>:
.globl vector128
vector128:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $128
80107619:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010761e:	e9 72 f6 ff ff       	jmp    80106c95 <alltraps>

80107623 <vector129>:
.globl vector129
vector129:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $129
80107625:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010762a:	e9 66 f6 ff ff       	jmp    80106c95 <alltraps>

8010762f <vector130>:
.globl vector130
vector130:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $130
80107631:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107636:	e9 5a f6 ff ff       	jmp    80106c95 <alltraps>

8010763b <vector131>:
.globl vector131
vector131:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $131
8010763d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107642:	e9 4e f6 ff ff       	jmp    80106c95 <alltraps>

80107647 <vector132>:
.globl vector132
vector132:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $132
80107649:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010764e:	e9 42 f6 ff ff       	jmp    80106c95 <alltraps>

80107653 <vector133>:
.globl vector133
vector133:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $133
80107655:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010765a:	e9 36 f6 ff ff       	jmp    80106c95 <alltraps>

8010765f <vector134>:
.globl vector134
vector134:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $134
80107661:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107666:	e9 2a f6 ff ff       	jmp    80106c95 <alltraps>

8010766b <vector135>:
.globl vector135
vector135:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $135
8010766d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107672:	e9 1e f6 ff ff       	jmp    80106c95 <alltraps>

80107677 <vector136>:
.globl vector136
vector136:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $136
80107679:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010767e:	e9 12 f6 ff ff       	jmp    80106c95 <alltraps>

80107683 <vector137>:
.globl vector137
vector137:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $137
80107685:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010768a:	e9 06 f6 ff ff       	jmp    80106c95 <alltraps>

8010768f <vector138>:
.globl vector138
vector138:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $138
80107691:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107696:	e9 fa f5 ff ff       	jmp    80106c95 <alltraps>

8010769b <vector139>:
.globl vector139
vector139:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $139
8010769d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801076a2:	e9 ee f5 ff ff       	jmp    80106c95 <alltraps>

801076a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $140
801076a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801076ae:	e9 e2 f5 ff ff       	jmp    80106c95 <alltraps>

801076b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $141
801076b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076ba:	e9 d6 f5 ff ff       	jmp    80106c95 <alltraps>

801076bf <vector142>:
.globl vector142
vector142:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $142
801076c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076c6:	e9 ca f5 ff ff       	jmp    80106c95 <alltraps>

801076cb <vector143>:
.globl vector143
vector143:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $143
801076cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076d2:	e9 be f5 ff ff       	jmp    80106c95 <alltraps>

801076d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $144
801076d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076de:	e9 b2 f5 ff ff       	jmp    80106c95 <alltraps>

801076e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $145
801076e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076ea:	e9 a6 f5 ff ff       	jmp    80106c95 <alltraps>

801076ef <vector146>:
.globl vector146
vector146:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $146
801076f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076f6:	e9 9a f5 ff ff       	jmp    80106c95 <alltraps>

801076fb <vector147>:
.globl vector147
vector147:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $147
801076fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107702:	e9 8e f5 ff ff       	jmp    80106c95 <alltraps>

80107707 <vector148>:
.globl vector148
vector148:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $148
80107709:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010770e:	e9 82 f5 ff ff       	jmp    80106c95 <alltraps>

80107713 <vector149>:
.globl vector149
vector149:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $149
80107715:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010771a:	e9 76 f5 ff ff       	jmp    80106c95 <alltraps>

8010771f <vector150>:
.globl vector150
vector150:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $150
80107721:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107726:	e9 6a f5 ff ff       	jmp    80106c95 <alltraps>

8010772b <vector151>:
.globl vector151
vector151:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $151
8010772d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107732:	e9 5e f5 ff ff       	jmp    80106c95 <alltraps>

80107737 <vector152>:
.globl vector152
vector152:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $152
80107739:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010773e:	e9 52 f5 ff ff       	jmp    80106c95 <alltraps>

80107743 <vector153>:
.globl vector153
vector153:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $153
80107745:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010774a:	e9 46 f5 ff ff       	jmp    80106c95 <alltraps>

8010774f <vector154>:
.globl vector154
vector154:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $154
80107751:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107756:	e9 3a f5 ff ff       	jmp    80106c95 <alltraps>

8010775b <vector155>:
.globl vector155
vector155:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $155
8010775d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107762:	e9 2e f5 ff ff       	jmp    80106c95 <alltraps>

80107767 <vector156>:
.globl vector156
vector156:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $156
80107769:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010776e:	e9 22 f5 ff ff       	jmp    80106c95 <alltraps>

80107773 <vector157>:
.globl vector157
vector157:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $157
80107775:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010777a:	e9 16 f5 ff ff       	jmp    80106c95 <alltraps>

8010777f <vector158>:
.globl vector158
vector158:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $158
80107781:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107786:	e9 0a f5 ff ff       	jmp    80106c95 <alltraps>

8010778b <vector159>:
.globl vector159
vector159:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $159
8010778d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107792:	e9 fe f4 ff ff       	jmp    80106c95 <alltraps>

80107797 <vector160>:
.globl vector160
vector160:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $160
80107799:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010779e:	e9 f2 f4 ff ff       	jmp    80106c95 <alltraps>

801077a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $161
801077a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801077aa:	e9 e6 f4 ff ff       	jmp    80106c95 <alltraps>

801077af <vector162>:
.globl vector162
vector162:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $162
801077b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077b6:	e9 da f4 ff ff       	jmp    80106c95 <alltraps>

801077bb <vector163>:
.globl vector163
vector163:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $163
801077bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077c2:	e9 ce f4 ff ff       	jmp    80106c95 <alltraps>

801077c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $164
801077c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077ce:	e9 c2 f4 ff ff       	jmp    80106c95 <alltraps>

801077d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $165
801077d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077da:	e9 b6 f4 ff ff       	jmp    80106c95 <alltraps>

801077df <vector166>:
.globl vector166
vector166:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $166
801077e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077e6:	e9 aa f4 ff ff       	jmp    80106c95 <alltraps>

801077eb <vector167>:
.globl vector167
vector167:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $167
801077ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077f2:	e9 9e f4 ff ff       	jmp    80106c95 <alltraps>

801077f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $168
801077f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801077fe:	e9 92 f4 ff ff       	jmp    80106c95 <alltraps>

80107803 <vector169>:
.globl vector169
vector169:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $169
80107805:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010780a:	e9 86 f4 ff ff       	jmp    80106c95 <alltraps>

8010780f <vector170>:
.globl vector170
vector170:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $170
80107811:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107816:	e9 7a f4 ff ff       	jmp    80106c95 <alltraps>

8010781b <vector171>:
.globl vector171
vector171:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $171
8010781d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107822:	e9 6e f4 ff ff       	jmp    80106c95 <alltraps>

80107827 <vector172>:
.globl vector172
vector172:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $172
80107829:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010782e:	e9 62 f4 ff ff       	jmp    80106c95 <alltraps>

80107833 <vector173>:
.globl vector173
vector173:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $173
80107835:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010783a:	e9 56 f4 ff ff       	jmp    80106c95 <alltraps>

8010783f <vector174>:
.globl vector174
vector174:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $174
80107841:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107846:	e9 4a f4 ff ff       	jmp    80106c95 <alltraps>

8010784b <vector175>:
.globl vector175
vector175:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $175
8010784d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107852:	e9 3e f4 ff ff       	jmp    80106c95 <alltraps>

80107857 <vector176>:
.globl vector176
vector176:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $176
80107859:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010785e:	e9 32 f4 ff ff       	jmp    80106c95 <alltraps>

80107863 <vector177>:
.globl vector177
vector177:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $177
80107865:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010786a:	e9 26 f4 ff ff       	jmp    80106c95 <alltraps>

8010786f <vector178>:
.globl vector178
vector178:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $178
80107871:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107876:	e9 1a f4 ff ff       	jmp    80106c95 <alltraps>

8010787b <vector179>:
.globl vector179
vector179:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $179
8010787d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107882:	e9 0e f4 ff ff       	jmp    80106c95 <alltraps>

80107887 <vector180>:
.globl vector180
vector180:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $180
80107889:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010788e:	e9 02 f4 ff ff       	jmp    80106c95 <alltraps>

80107893 <vector181>:
.globl vector181
vector181:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $181
80107895:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010789a:	e9 f6 f3 ff ff       	jmp    80106c95 <alltraps>

8010789f <vector182>:
.globl vector182
vector182:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $182
801078a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801078a6:	e9 ea f3 ff ff       	jmp    80106c95 <alltraps>

801078ab <vector183>:
.globl vector183
vector183:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $183
801078ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078b2:	e9 de f3 ff ff       	jmp    80106c95 <alltraps>

801078b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $184
801078b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078be:	e9 d2 f3 ff ff       	jmp    80106c95 <alltraps>

801078c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $185
801078c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078ca:	e9 c6 f3 ff ff       	jmp    80106c95 <alltraps>

801078cf <vector186>:
.globl vector186
vector186:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $186
801078d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078d6:	e9 ba f3 ff ff       	jmp    80106c95 <alltraps>

801078db <vector187>:
.globl vector187
vector187:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $187
801078dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078e2:	e9 ae f3 ff ff       	jmp    80106c95 <alltraps>

801078e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $188
801078e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078ee:	e9 a2 f3 ff ff       	jmp    80106c95 <alltraps>

801078f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $189
801078f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078fa:	e9 96 f3 ff ff       	jmp    80106c95 <alltraps>

801078ff <vector190>:
.globl vector190
vector190:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $190
80107901:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107906:	e9 8a f3 ff ff       	jmp    80106c95 <alltraps>

8010790b <vector191>:
.globl vector191
vector191:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $191
8010790d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107912:	e9 7e f3 ff ff       	jmp    80106c95 <alltraps>

80107917 <vector192>:
.globl vector192
vector192:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $192
80107919:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010791e:	e9 72 f3 ff ff       	jmp    80106c95 <alltraps>

80107923 <vector193>:
.globl vector193
vector193:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $193
80107925:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010792a:	e9 66 f3 ff ff       	jmp    80106c95 <alltraps>

8010792f <vector194>:
.globl vector194
vector194:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $194
80107931:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107936:	e9 5a f3 ff ff       	jmp    80106c95 <alltraps>

8010793b <vector195>:
.globl vector195
vector195:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $195
8010793d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107942:	e9 4e f3 ff ff       	jmp    80106c95 <alltraps>

80107947 <vector196>:
.globl vector196
vector196:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $196
80107949:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010794e:	e9 42 f3 ff ff       	jmp    80106c95 <alltraps>

80107953 <vector197>:
.globl vector197
vector197:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $197
80107955:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010795a:	e9 36 f3 ff ff       	jmp    80106c95 <alltraps>

8010795f <vector198>:
.globl vector198
vector198:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $198
80107961:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107966:	e9 2a f3 ff ff       	jmp    80106c95 <alltraps>

8010796b <vector199>:
.globl vector199
vector199:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $199
8010796d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107972:	e9 1e f3 ff ff       	jmp    80106c95 <alltraps>

80107977 <vector200>:
.globl vector200
vector200:
  pushl $0
80107977:	6a 00                	push   $0x0
  pushl $200
80107979:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010797e:	e9 12 f3 ff ff       	jmp    80106c95 <alltraps>

80107983 <vector201>:
.globl vector201
vector201:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $201
80107985:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010798a:	e9 06 f3 ff ff       	jmp    80106c95 <alltraps>

8010798f <vector202>:
.globl vector202
vector202:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $202
80107991:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107996:	e9 fa f2 ff ff       	jmp    80106c95 <alltraps>

8010799b <vector203>:
.globl vector203
vector203:
  pushl $0
8010799b:	6a 00                	push   $0x0
  pushl $203
8010799d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801079a2:	e9 ee f2 ff ff       	jmp    80106c95 <alltraps>

801079a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $204
801079a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801079ae:	e9 e2 f2 ff ff       	jmp    80106c95 <alltraps>

801079b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $205
801079b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079ba:	e9 d6 f2 ff ff       	jmp    80106c95 <alltraps>

801079bf <vector206>:
.globl vector206
vector206:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $206
801079c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079c6:	e9 ca f2 ff ff       	jmp    80106c95 <alltraps>

801079cb <vector207>:
.globl vector207
vector207:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $207
801079cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079d2:	e9 be f2 ff ff       	jmp    80106c95 <alltraps>

801079d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $208
801079d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079de:	e9 b2 f2 ff ff       	jmp    80106c95 <alltraps>

801079e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $209
801079e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079ea:	e9 a6 f2 ff ff       	jmp    80106c95 <alltraps>

801079ef <vector210>:
.globl vector210
vector210:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $210
801079f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079f6:	e9 9a f2 ff ff       	jmp    80106c95 <alltraps>

801079fb <vector211>:
.globl vector211
vector211:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $211
801079fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a02:	e9 8e f2 ff ff       	jmp    80106c95 <alltraps>

80107a07 <vector212>:
.globl vector212
vector212:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $212
80107a09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a0e:	e9 82 f2 ff ff       	jmp    80106c95 <alltraps>

80107a13 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $213
80107a15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a1a:	e9 76 f2 ff ff       	jmp    80106c95 <alltraps>

80107a1f <vector214>:
.globl vector214
vector214:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $214
80107a21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a26:	e9 6a f2 ff ff       	jmp    80106c95 <alltraps>

80107a2b <vector215>:
.globl vector215
vector215:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $215
80107a2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a32:	e9 5e f2 ff ff       	jmp    80106c95 <alltraps>

80107a37 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $216
80107a39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a3e:	e9 52 f2 ff ff       	jmp    80106c95 <alltraps>

80107a43 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $217
80107a45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a4a:	e9 46 f2 ff ff       	jmp    80106c95 <alltraps>

80107a4f <vector218>:
.globl vector218
vector218:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $218
80107a51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a56:	e9 3a f2 ff ff       	jmp    80106c95 <alltraps>

80107a5b <vector219>:
.globl vector219
vector219:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $219
80107a5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a62:	e9 2e f2 ff ff       	jmp    80106c95 <alltraps>

80107a67 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $220
80107a69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a6e:	e9 22 f2 ff ff       	jmp    80106c95 <alltraps>

80107a73 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $221
80107a75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a7a:	e9 16 f2 ff ff       	jmp    80106c95 <alltraps>

80107a7f <vector222>:
.globl vector222
vector222:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $222
80107a81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a86:	e9 0a f2 ff ff       	jmp    80106c95 <alltraps>

80107a8b <vector223>:
.globl vector223
vector223:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $223
80107a8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a92:	e9 fe f1 ff ff       	jmp    80106c95 <alltraps>

80107a97 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $224
80107a99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a9e:	e9 f2 f1 ff ff       	jmp    80106c95 <alltraps>

80107aa3 <vector225>:
.globl vector225
vector225:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $225
80107aa5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107aaa:	e9 e6 f1 ff ff       	jmp    80106c95 <alltraps>

80107aaf <vector226>:
.globl vector226
vector226:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $226
80107ab1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107ab6:	e9 da f1 ff ff       	jmp    80106c95 <alltraps>

80107abb <vector227>:
.globl vector227
vector227:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $227
80107abd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ac2:	e9 ce f1 ff ff       	jmp    80106c95 <alltraps>

80107ac7 <vector228>:
.globl vector228
vector228:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $228
80107ac9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107ace:	e9 c2 f1 ff ff       	jmp    80106c95 <alltraps>

80107ad3 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $229
80107ad5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107ada:	e9 b6 f1 ff ff       	jmp    80106c95 <alltraps>

80107adf <vector230>:
.globl vector230
vector230:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $230
80107ae1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ae6:	e9 aa f1 ff ff       	jmp    80106c95 <alltraps>

80107aeb <vector231>:
.globl vector231
vector231:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $231
80107aed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107af2:	e9 9e f1 ff ff       	jmp    80106c95 <alltraps>

80107af7 <vector232>:
.globl vector232
vector232:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $232
80107af9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107afe:	e9 92 f1 ff ff       	jmp    80106c95 <alltraps>

80107b03 <vector233>:
.globl vector233
vector233:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $233
80107b05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b0a:	e9 86 f1 ff ff       	jmp    80106c95 <alltraps>

80107b0f <vector234>:
.globl vector234
vector234:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $234
80107b11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b16:	e9 7a f1 ff ff       	jmp    80106c95 <alltraps>

80107b1b <vector235>:
.globl vector235
vector235:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $235
80107b1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b22:	e9 6e f1 ff ff       	jmp    80106c95 <alltraps>

80107b27 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $236
80107b29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b2e:	e9 62 f1 ff ff       	jmp    80106c95 <alltraps>

80107b33 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $237
80107b35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b3a:	e9 56 f1 ff ff       	jmp    80106c95 <alltraps>

80107b3f <vector238>:
.globl vector238
vector238:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $238
80107b41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b46:	e9 4a f1 ff ff       	jmp    80106c95 <alltraps>

80107b4b <vector239>:
.globl vector239
vector239:
  pushl $0
80107b4b:	6a 00                	push   $0x0
  pushl $239
80107b4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b52:	e9 3e f1 ff ff       	jmp    80106c95 <alltraps>

80107b57 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $240
80107b59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b5e:	e9 32 f1 ff ff       	jmp    80106c95 <alltraps>

80107b63 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b63:	6a 00                	push   $0x0
  pushl $241
80107b65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b6a:	e9 26 f1 ff ff       	jmp    80106c95 <alltraps>

80107b6f <vector242>:
.globl vector242
vector242:
  pushl $0
80107b6f:	6a 00                	push   $0x0
  pushl $242
80107b71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b76:	e9 1a f1 ff ff       	jmp    80106c95 <alltraps>

80107b7b <vector243>:
.globl vector243
vector243:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $243
80107b7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b82:	e9 0e f1 ff ff       	jmp    80106c95 <alltraps>

80107b87 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b87:	6a 00                	push   $0x0
  pushl $244
80107b89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b8e:	e9 02 f1 ff ff       	jmp    80106c95 <alltraps>

80107b93 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b93:	6a 00                	push   $0x0
  pushl $245
80107b95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b9a:	e9 f6 f0 ff ff       	jmp    80106c95 <alltraps>

80107b9f <vector246>:
.globl vector246
vector246:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $246
80107ba1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ba6:	e9 ea f0 ff ff       	jmp    80106c95 <alltraps>

80107bab <vector247>:
.globl vector247
vector247:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $247
80107bad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107bb2:	e9 de f0 ff ff       	jmp    80106c95 <alltraps>

80107bb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80107bb7:	6a 00                	push   $0x0
  pushl $248
80107bb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bbe:	e9 d2 f0 ff ff       	jmp    80106c95 <alltraps>

80107bc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $249
80107bc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bca:	e9 c6 f0 ff ff       	jmp    80106c95 <alltraps>

80107bcf <vector250>:
.globl vector250
vector250:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $250
80107bd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107bd6:	e9 ba f0 ff ff       	jmp    80106c95 <alltraps>

80107bdb <vector251>:
.globl vector251
vector251:
  pushl $0
80107bdb:	6a 00                	push   $0x0
  pushl $251
80107bdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107be2:	e9 ae f0 ff ff       	jmp    80106c95 <alltraps>

80107be7 <vector252>:
.globl vector252
vector252:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $252
80107be9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bee:	e9 a2 f0 ff ff       	jmp    80106c95 <alltraps>

80107bf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $253
80107bf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107bfa:	e9 96 f0 ff ff       	jmp    80106c95 <alltraps>

80107bff <vector254>:
.globl vector254
vector254:
  pushl $0
80107bff:	6a 00                	push   $0x0
  pushl $254
80107c01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c06:	e9 8a f0 ff ff       	jmp    80106c95 <alltraps>

80107c0b <vector255>:
.globl vector255
vector255:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $255
80107c0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c12:	e9 7e f0 ff ff       	jmp    80106c95 <alltraps>
80107c17:	66 90                	xchg   %ax,%ax
80107c19:	66 90                	xchg   %ax,%ax
80107c1b:	66 90                	xchg   %ax,%ax
80107c1d:	66 90                	xchg   %ax,%ax
80107c1f:	90                   	nop

80107c20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	57                   	push   %edi
80107c24:	56                   	push   %esi
80107c25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107c26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107c2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107c32:	83 ec 1c             	sub    $0x1c,%esp
80107c35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c38:	39 d3                	cmp    %edx,%ebx
80107c3a:	73 49                	jae    80107c85 <deallocuvm.part.0+0x65>
80107c3c:	89 c7                	mov    %eax,%edi
80107c3e:	eb 0c                	jmp    80107c4c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c40:	83 c0 01             	add    $0x1,%eax
80107c43:	c1 e0 16             	shl    $0x16,%eax
80107c46:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107c48:	39 da                	cmp    %ebx,%edx
80107c4a:	76 39                	jbe    80107c85 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107c4c:	89 d8                	mov    %ebx,%eax
80107c4e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107c51:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107c54:	f6 c1 01             	test   $0x1,%cl
80107c57:	74 e7                	je     80107c40 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107c59:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107c61:	c1 ee 0a             	shr    $0xa,%esi
80107c64:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107c6a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107c71:	85 f6                	test   %esi,%esi
80107c73:	74 cb                	je     80107c40 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107c75:	8b 06                	mov    (%esi),%eax
80107c77:	a8 01                	test   $0x1,%al
80107c79:	75 15                	jne    80107c90 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107c7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c81:	39 da                	cmp    %ebx,%edx
80107c83:	77 c7                	ja     80107c4c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c8b:	5b                   	pop    %ebx
80107c8c:	5e                   	pop    %esi
80107c8d:	5f                   	pop    %edi
80107c8e:	5d                   	pop    %ebp
80107c8f:	c3                   	ret    
      if(pa == 0)
80107c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c95:	74 25                	je     80107cbc <deallocuvm.part.0+0x9c>
      kfree(v);
80107c97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107c9a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107ca2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107ca8:	50                   	push   %eax
80107ca9:	e8 12 a8 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80107cae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107cb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cb7:	83 c4 10             	add    $0x10,%esp
80107cba:	eb 8c                	jmp    80107c48 <deallocuvm.part.0+0x28>
        panic("kfree");
80107cbc:	83 ec 0c             	sub    $0xc,%esp
80107cbf:	68 86 88 10 80       	push   $0x80108886
80107cc4:	e8 b7 86 ff ff       	call   80100380 <panic>
80107cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107cd0 <mappages>:
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	57                   	push   %edi
80107cd4:	56                   	push   %esi
80107cd5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107cd6:	89 d3                	mov    %edx,%ebx
80107cd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107cde:	83 ec 1c             	sub    $0x1c,%esp
80107ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ce4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ced:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf3:	29 d8                	sub    %ebx,%eax
80107cf5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107cf8:	eb 3d                	jmp    80107d37 <mappages+0x67>
80107cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107d00:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107d07:	c1 ea 0a             	shr    $0xa,%edx
80107d0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107d10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d17:	85 c0                	test   %eax,%eax
80107d19:	74 75                	je     80107d90 <mappages+0xc0>
    if(*pte & PTE_P)
80107d1b:	f6 00 01             	testb  $0x1,(%eax)
80107d1e:	0f 85 86 00 00 00    	jne    80107daa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107d24:	0b 75 0c             	or     0xc(%ebp),%esi
80107d27:	83 ce 01             	or     $0x1,%esi
80107d2a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107d2c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107d2f:	74 6f                	je     80107da0 <mappages+0xd0>
    a += PGSIZE;
80107d31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107d3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107d3d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107d40:	89 d8                	mov    %ebx,%eax
80107d42:	c1 e8 16             	shr    $0x16,%eax
80107d45:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107d48:	8b 07                	mov    (%edi),%eax
80107d4a:	a8 01                	test   $0x1,%al
80107d4c:	75 b2                	jne    80107d00 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d4e:	e8 2d a9 ff ff       	call   80102680 <kalloc>
80107d53:	85 c0                	test   %eax,%eax
80107d55:	74 39                	je     80107d90 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107d57:	83 ec 04             	sub    $0x4,%esp
80107d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107d5d:	68 00 10 00 00       	push   $0x1000
80107d62:	6a 00                	push   $0x0
80107d64:	50                   	push   %eax
80107d65:	e8 66 db ff ff       	call   801058d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107d6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107d6d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107d70:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107d76:	83 c8 07             	or     $0x7,%eax
80107d79:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107d7b:	89 d8                	mov    %ebx,%eax
80107d7d:	c1 e8 0a             	shr    $0xa,%eax
80107d80:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d85:	01 d0                	add    %edx,%eax
80107d87:	eb 92                	jmp    80107d1b <mappages+0x4b>
80107d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d98:	5b                   	pop    %ebx
80107d99:	5e                   	pop    %esi
80107d9a:	5f                   	pop    %edi
80107d9b:	5d                   	pop    %ebp
80107d9c:	c3                   	ret    
80107d9d:	8d 76 00             	lea    0x0(%esi),%esi
80107da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107da3:	31 c0                	xor    %eax,%eax
}
80107da5:	5b                   	pop    %ebx
80107da6:	5e                   	pop    %esi
80107da7:	5f                   	pop    %edi
80107da8:	5d                   	pop    %ebp
80107da9:	c3                   	ret    
      panic("remap");
80107daa:	83 ec 0c             	sub    $0xc,%esp
80107dad:	68 d0 8e 10 80       	push   $0x80108ed0
80107db2:	e8 c9 85 ff ff       	call   80100380 <panic>
80107db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbe:	66 90                	xchg   %ax,%ax

80107dc0 <seginit>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107dc6:	e8 c5 c4 ff ff       	call   80104290 <cpuid>
  pd[0] = size-1;
80107dcb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107dd0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107dd6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107dda:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107de1:	ff 00 00 
80107de4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80107deb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107dee:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107df5:	ff 00 00 
80107df8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80107dff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e02:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107e09:	ff 00 00 
80107e0c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107e13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e16:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80107e1d:	ff 00 00 
80107e20:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107e27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107e2a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80107e2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107e33:	c1 e8 10             	shr    $0x10,%eax
80107e36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107e3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107e3d:	0f 01 10             	lgdtl  (%eax)
}
80107e40:	c9                   	leave  
80107e41:	c3                   	ret    
80107e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e50:	a1 e4 5b 11 80       	mov    0x80115be4,%eax
80107e55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e5a:	0f 22 d8             	mov    %eax,%cr3
}
80107e5d:	c3                   	ret    
80107e5e:	66 90                	xchg   %ax,%ax

80107e60 <switchuvm>:
{
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	57                   	push   %edi
80107e64:	56                   	push   %esi
80107e65:	53                   	push   %ebx
80107e66:	83 ec 1c             	sub    $0x1c,%esp
80107e69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107e6c:	85 f6                	test   %esi,%esi
80107e6e:	0f 84 cb 00 00 00    	je     80107f3f <switchuvm+0xdf>
  if(p->kstack == 0)
80107e74:	8b 46 08             	mov    0x8(%esi),%eax
80107e77:	85 c0                	test   %eax,%eax
80107e79:	0f 84 da 00 00 00    	je     80107f59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107e7f:	8b 46 04             	mov    0x4(%esi),%eax
80107e82:	85 c0                	test   %eax,%eax
80107e84:	0f 84 c2 00 00 00    	je     80107f4c <switchuvm+0xec>
  pushcli();
80107e8a:	e8 31 d8 ff ff       	call   801056c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e8f:	e8 9c c3 ff ff       	call   80104230 <mycpu>
80107e94:	89 c3                	mov    %eax,%ebx
80107e96:	e8 95 c3 ff ff       	call   80104230 <mycpu>
80107e9b:	89 c7                	mov    %eax,%edi
80107e9d:	e8 8e c3 ff ff       	call   80104230 <mycpu>
80107ea2:	83 c7 08             	add    $0x8,%edi
80107ea5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ea8:	e8 83 c3 ff ff       	call   80104230 <mycpu>
80107ead:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107eb0:	ba 67 00 00 00       	mov    $0x67,%edx
80107eb5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107ebc:	83 c0 08             	add    $0x8,%eax
80107ebf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ec6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107ecb:	83 c1 08             	add    $0x8,%ecx
80107ece:	c1 e8 18             	shr    $0x18,%eax
80107ed1:	c1 e9 10             	shr    $0x10,%ecx
80107ed4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107eda:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107ee0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107ee5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107eec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107ef1:	e8 3a c3 ff ff       	call   80104230 <mycpu>
80107ef6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107efd:	e8 2e c3 ff ff       	call   80104230 <mycpu>
80107f02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f06:	8b 5e 08             	mov    0x8(%esi),%ebx
80107f09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f0f:	e8 1c c3 ff ff       	call   80104230 <mycpu>
80107f14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f17:	e8 14 c3 ff ff       	call   80104230 <mycpu>
80107f1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107f20:	b8 28 00 00 00       	mov    $0x28,%eax
80107f25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f28:	8b 46 04             	mov    0x4(%esi),%eax
80107f2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f30:	0f 22 d8             	mov    %eax,%cr3
}
80107f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f36:	5b                   	pop    %ebx
80107f37:	5e                   	pop    %esi
80107f38:	5f                   	pop    %edi
80107f39:	5d                   	pop    %ebp
  popcli();
80107f3a:	e9 d1 d7 ff ff       	jmp    80105710 <popcli>
    panic("switchuvm: no process");
80107f3f:	83 ec 0c             	sub    $0xc,%esp
80107f42:	68 d6 8e 10 80       	push   $0x80108ed6
80107f47:	e8 34 84 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107f4c:	83 ec 0c             	sub    $0xc,%esp
80107f4f:	68 01 8f 10 80       	push   $0x80108f01
80107f54:	e8 27 84 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107f59:	83 ec 0c             	sub    $0xc,%esp
80107f5c:	68 ec 8e 10 80       	push   $0x80108eec
80107f61:	e8 1a 84 ff ff       	call   80100380 <panic>
80107f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6d:	8d 76 00             	lea    0x0(%esi),%esi

80107f70 <inituvm>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	57                   	push   %edi
80107f74:	56                   	push   %esi
80107f75:	53                   	push   %ebx
80107f76:	83 ec 1c             	sub    $0x1c,%esp
80107f79:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7c:	8b 75 10             	mov    0x10(%ebp),%esi
80107f7f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107f82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107f85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107f8b:	77 4b                	ja     80107fd8 <inituvm+0x68>
  mem = kalloc();
80107f8d:	e8 ee a6 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107f92:	83 ec 04             	sub    $0x4,%esp
80107f95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107f9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107f9c:	6a 00                	push   $0x0
80107f9e:	50                   	push   %eax
80107f9f:	e8 2c d9 ff ff       	call   801058d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107fa4:	58                   	pop    %eax
80107fa5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107fab:	5a                   	pop    %edx
80107fac:	6a 06                	push   $0x6
80107fae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107fb3:	31 d2                	xor    %edx,%edx
80107fb5:	50                   	push   %eax
80107fb6:	89 f8                	mov    %edi,%eax
80107fb8:	e8 13 fd ff ff       	call   80107cd0 <mappages>
  memmove(mem, init, sz);
80107fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fc0:	89 75 10             	mov    %esi,0x10(%ebp)
80107fc3:	83 c4 10             	add    $0x10,%esp
80107fc6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107fc9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fcf:	5b                   	pop    %ebx
80107fd0:	5e                   	pop    %esi
80107fd1:	5f                   	pop    %edi
80107fd2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107fd3:	e9 98 d9 ff ff       	jmp    80105970 <memmove>
    panic("inituvm: more than a page");
80107fd8:	83 ec 0c             	sub    $0xc,%esp
80107fdb:	68 15 8f 10 80       	push   $0x80108f15
80107fe0:	e8 9b 83 ff ff       	call   80100380 <panic>
80107fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ff0 <loaduvm>:
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	57                   	push   %edi
80107ff4:	56                   	push   %esi
80107ff5:	53                   	push   %ebx
80107ff6:	83 ec 1c             	sub    $0x1c,%esp
80107ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ffc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107fff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108004:	0f 85 bb 00 00 00    	jne    801080c5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010800a:	01 f0                	add    %esi,%eax
8010800c:	89 f3                	mov    %esi,%ebx
8010800e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108011:	8b 45 14             	mov    0x14(%ebp),%eax
80108014:	01 f0                	add    %esi,%eax
80108016:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108019:	85 f6                	test   %esi,%esi
8010801b:	0f 84 87 00 00 00    	je     801080a8 <loaduvm+0xb8>
80108021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010802b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010802e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108030:	89 c2                	mov    %eax,%edx
80108032:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108035:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108038:	f6 c2 01             	test   $0x1,%dl
8010803b:	75 13                	jne    80108050 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010803d:	83 ec 0c             	sub    $0xc,%esp
80108040:	68 2f 8f 10 80       	push   $0x80108f2f
80108045:	e8 36 83 ff ff       	call   80100380 <panic>
8010804a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108050:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108053:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108059:	25 fc 0f 00 00       	and    $0xffc,%eax
8010805e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108065:	85 c0                	test   %eax,%eax
80108067:	74 d4                	je     8010803d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80108069:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010806b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010806e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108073:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108078:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010807e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108081:	29 d9                	sub    %ebx,%ecx
80108083:	05 00 00 00 80       	add    $0x80000000,%eax
80108088:	57                   	push   %edi
80108089:	51                   	push   %ecx
8010808a:	50                   	push   %eax
8010808b:	ff 75 10             	push   0x10(%ebp)
8010808e:	e8 fd 99 ff ff       	call   80101a90 <readi>
80108093:	83 c4 10             	add    $0x10,%esp
80108096:	39 f8                	cmp    %edi,%eax
80108098:	75 1e                	jne    801080b8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010809a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801080a0:	89 f0                	mov    %esi,%eax
801080a2:	29 d8                	sub    %ebx,%eax
801080a4:	39 c6                	cmp    %eax,%esi
801080a6:	77 80                	ja     80108028 <loaduvm+0x38>
}
801080a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080ab:	31 c0                	xor    %eax,%eax
}
801080ad:	5b                   	pop    %ebx
801080ae:	5e                   	pop    %esi
801080af:	5f                   	pop    %edi
801080b0:	5d                   	pop    %ebp
801080b1:	c3                   	ret    
801080b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080c0:	5b                   	pop    %ebx
801080c1:	5e                   	pop    %esi
801080c2:	5f                   	pop    %edi
801080c3:	5d                   	pop    %ebp
801080c4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801080c5:	83 ec 0c             	sub    $0xc,%esp
801080c8:	68 d0 8f 10 80       	push   $0x80108fd0
801080cd:	e8 ae 82 ff ff       	call   80100380 <panic>
801080d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080e0 <allocuvm>:
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	57                   	push   %edi
801080e4:	56                   	push   %esi
801080e5:	53                   	push   %ebx
801080e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801080e9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801080ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801080ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080f2:	85 c0                	test   %eax,%eax
801080f4:	0f 88 b6 00 00 00    	js     801081b0 <allocuvm+0xd0>
  if(newsz < oldsz)
801080fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801080fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108100:	0f 82 9a 00 00 00    	jb     801081a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108106:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010810c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108112:	39 75 10             	cmp    %esi,0x10(%ebp)
80108115:	77 44                	ja     8010815b <allocuvm+0x7b>
80108117:	e9 87 00 00 00       	jmp    801081a3 <allocuvm+0xc3>
8010811c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108120:	83 ec 04             	sub    $0x4,%esp
80108123:	68 00 10 00 00       	push   $0x1000
80108128:	6a 00                	push   $0x0
8010812a:	50                   	push   %eax
8010812b:	e8 a0 d7 ff ff       	call   801058d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108130:	58                   	pop    %eax
80108131:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108137:	5a                   	pop    %edx
80108138:	6a 06                	push   $0x6
8010813a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010813f:	89 f2                	mov    %esi,%edx
80108141:	50                   	push   %eax
80108142:	89 f8                	mov    %edi,%eax
80108144:	e8 87 fb ff ff       	call   80107cd0 <mappages>
80108149:	83 c4 10             	add    $0x10,%esp
8010814c:	85 c0                	test   %eax,%eax
8010814e:	78 78                	js     801081c8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108150:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108156:	39 75 10             	cmp    %esi,0x10(%ebp)
80108159:	76 48                	jbe    801081a3 <allocuvm+0xc3>
    mem = kalloc();
8010815b:	e8 20 a5 ff ff       	call   80102680 <kalloc>
80108160:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108162:	85 c0                	test   %eax,%eax
80108164:	75 ba                	jne    80108120 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108166:	83 ec 0c             	sub    $0xc,%esp
80108169:	68 4d 8f 10 80       	push   $0x80108f4d
8010816e:	e8 2d 85 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80108173:	8b 45 0c             	mov    0xc(%ebp),%eax
80108176:	83 c4 10             	add    $0x10,%esp
80108179:	39 45 10             	cmp    %eax,0x10(%ebp)
8010817c:	74 32                	je     801081b0 <allocuvm+0xd0>
8010817e:	8b 55 10             	mov    0x10(%ebp),%edx
80108181:	89 c1                	mov    %eax,%ecx
80108183:	89 f8                	mov    %edi,%eax
80108185:	e8 96 fa ff ff       	call   80107c20 <deallocuvm.part.0>
      return 0;
8010818a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108197:	5b                   	pop    %ebx
80108198:	5e                   	pop    %esi
80108199:	5f                   	pop    %edi
8010819a:	5d                   	pop    %ebp
8010819b:	c3                   	ret    
8010819c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801081a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801081a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081a9:	5b                   	pop    %ebx
801081aa:	5e                   	pop    %esi
801081ab:	5f                   	pop    %edi
801081ac:	5d                   	pop    %ebp
801081ad:	c3                   	ret    
801081ae:	66 90                	xchg   %ax,%ax
    return 0;
801081b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801081b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081bd:	5b                   	pop    %ebx
801081be:	5e                   	pop    %esi
801081bf:	5f                   	pop    %edi
801081c0:	5d                   	pop    %ebp
801081c1:	c3                   	ret    
801081c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801081c8:	83 ec 0c             	sub    $0xc,%esp
801081cb:	68 65 8f 10 80       	push   $0x80108f65
801081d0:	e8 cb 84 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801081d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801081d8:	83 c4 10             	add    $0x10,%esp
801081db:	39 45 10             	cmp    %eax,0x10(%ebp)
801081de:	74 0c                	je     801081ec <allocuvm+0x10c>
801081e0:	8b 55 10             	mov    0x10(%ebp),%edx
801081e3:	89 c1                	mov    %eax,%ecx
801081e5:	89 f8                	mov    %edi,%eax
801081e7:	e8 34 fa ff ff       	call   80107c20 <deallocuvm.part.0>
      kfree(mem);
801081ec:	83 ec 0c             	sub    $0xc,%esp
801081ef:	53                   	push   %ebx
801081f0:	e8 cb a2 ff ff       	call   801024c0 <kfree>
      return 0;
801081f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801081fc:	83 c4 10             	add    $0x10,%esp
}
801081ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108205:	5b                   	pop    %ebx
80108206:	5e                   	pop    %esi
80108207:	5f                   	pop    %edi
80108208:	5d                   	pop    %ebp
80108209:	c3                   	ret    
8010820a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108210 <deallocuvm>:
{
80108210:	55                   	push   %ebp
80108211:	89 e5                	mov    %esp,%ebp
80108213:	8b 55 0c             	mov    0xc(%ebp),%edx
80108216:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108219:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010821c:	39 d1                	cmp    %edx,%ecx
8010821e:	73 10                	jae    80108230 <deallocuvm+0x20>
}
80108220:	5d                   	pop    %ebp
80108221:	e9 fa f9 ff ff       	jmp    80107c20 <deallocuvm.part.0>
80108226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010822d:	8d 76 00             	lea    0x0(%esi),%esi
80108230:	89 d0                	mov    %edx,%eax
80108232:	5d                   	pop    %ebp
80108233:	c3                   	ret    
80108234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010823f:	90                   	nop

80108240 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	57                   	push   %edi
80108244:	56                   	push   %esi
80108245:	53                   	push   %ebx
80108246:	83 ec 0c             	sub    $0xc,%esp
80108249:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010824c:	85 f6                	test   %esi,%esi
8010824e:	74 59                	je     801082a9 <freevm+0x69>
  if(newsz >= oldsz)
80108250:	31 c9                	xor    %ecx,%ecx
80108252:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108257:	89 f0                	mov    %esi,%eax
80108259:	89 f3                	mov    %esi,%ebx
8010825b:	e8 c0 f9 ff ff       	call   80107c20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108260:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108266:	eb 0f                	jmp    80108277 <freevm+0x37>
80108268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010826f:	90                   	nop
80108270:	83 c3 04             	add    $0x4,%ebx
80108273:	39 df                	cmp    %ebx,%edi
80108275:	74 23                	je     8010829a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108277:	8b 03                	mov    (%ebx),%eax
80108279:	a8 01                	test   $0x1,%al
8010827b:	74 f3                	je     80108270 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010827d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108282:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108285:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108288:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010828d:	50                   	push   %eax
8010828e:	e8 2d a2 ff ff       	call   801024c0 <kfree>
80108293:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108296:	39 df                	cmp    %ebx,%edi
80108298:	75 dd                	jne    80108277 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010829a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010829d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082a0:	5b                   	pop    %ebx
801082a1:	5e                   	pop    %esi
801082a2:	5f                   	pop    %edi
801082a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801082a4:	e9 17 a2 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801082a9:	83 ec 0c             	sub    $0xc,%esp
801082ac:	68 81 8f 10 80       	push   $0x80108f81
801082b1:	e8 ca 80 ff ff       	call   80100380 <panic>
801082b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082bd:	8d 76 00             	lea    0x0(%esi),%esi

801082c0 <setupkvm>:
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	56                   	push   %esi
801082c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801082c5:	e8 b6 a3 ff ff       	call   80102680 <kalloc>
801082ca:	89 c6                	mov    %eax,%esi
801082cc:	85 c0                	test   %eax,%eax
801082ce:	74 42                	je     80108312 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801082d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801082d8:	68 00 10 00 00       	push   $0x1000
801082dd:	6a 00                	push   $0x0
801082df:	50                   	push   %eax
801082e0:	e8 eb d5 ff ff       	call   801058d0 <memset>
801082e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801082e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082eb:	83 ec 08             	sub    $0x8,%esp
801082ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801082f1:	ff 73 0c             	push   0xc(%ebx)
801082f4:	8b 13                	mov    (%ebx),%edx
801082f6:	50                   	push   %eax
801082f7:	29 c1                	sub    %eax,%ecx
801082f9:	89 f0                	mov    %esi,%eax
801082fb:	e8 d0 f9 ff ff       	call   80107cd0 <mappages>
80108300:	83 c4 10             	add    $0x10,%esp
80108303:	85 c0                	test   %eax,%eax
80108305:	78 19                	js     80108320 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108307:	83 c3 10             	add    $0x10,%ebx
8010830a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80108310:	75 d6                	jne    801082e8 <setupkvm+0x28>
}
80108312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108315:	89 f0                	mov    %esi,%eax
80108317:	5b                   	pop    %ebx
80108318:	5e                   	pop    %esi
80108319:	5d                   	pop    %ebp
8010831a:	c3                   	ret    
8010831b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010831f:	90                   	nop
      freevm(pgdir);
80108320:	83 ec 0c             	sub    $0xc,%esp
80108323:	56                   	push   %esi
      return 0;
80108324:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108326:	e8 15 ff ff ff       	call   80108240 <freevm>
      return 0;
8010832b:	83 c4 10             	add    $0x10,%esp
}
8010832e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108331:	89 f0                	mov    %esi,%eax
80108333:	5b                   	pop    %ebx
80108334:	5e                   	pop    %esi
80108335:	5d                   	pop    %ebp
80108336:	c3                   	ret    
80108337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010833e:	66 90                	xchg   %ax,%ax

80108340 <kvmalloc>:
{
80108340:	55                   	push   %ebp
80108341:	89 e5                	mov    %esp,%ebp
80108343:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108346:	e8 75 ff ff ff       	call   801082c0 <setupkvm>
8010834b:	a3 e4 5b 11 80       	mov    %eax,0x80115be4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108350:	05 00 00 00 80       	add    $0x80000000,%eax
80108355:	0f 22 d8             	mov    %eax,%cr3
}
80108358:	c9                   	leave  
80108359:	c3                   	ret    
8010835a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108360:	55                   	push   %ebp
80108361:	89 e5                	mov    %esp,%ebp
80108363:	83 ec 08             	sub    $0x8,%esp
80108366:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108369:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010836c:	89 c1                	mov    %eax,%ecx
8010836e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108371:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108374:	f6 c2 01             	test   $0x1,%dl
80108377:	75 17                	jne    80108390 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108379:	83 ec 0c             	sub    $0xc,%esp
8010837c:	68 92 8f 10 80       	push   $0x80108f92
80108381:	e8 fa 7f ff ff       	call   80100380 <panic>
80108386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010838d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108390:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108393:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108399:	25 fc 0f 00 00       	and    $0xffc,%eax
8010839e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801083a5:	85 c0                	test   %eax,%eax
801083a7:	74 d0                	je     80108379 <clearpteu+0x19>
  *pte &= ~PTE_U;
801083a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801083ac:	c9                   	leave  
801083ad:	c3                   	ret    
801083ae:	66 90                	xchg   %ax,%ax

801083b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801083b0:	55                   	push   %ebp
801083b1:	89 e5                	mov    %esp,%ebp
801083b3:	57                   	push   %edi
801083b4:	56                   	push   %esi
801083b5:	53                   	push   %ebx
801083b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801083b9:	e8 02 ff ff ff       	call   801082c0 <setupkvm>
801083be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083c1:	85 c0                	test   %eax,%eax
801083c3:	0f 84 bd 00 00 00    	je     80108486 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801083c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801083cc:	85 c9                	test   %ecx,%ecx
801083ce:	0f 84 b2 00 00 00    	je     80108486 <copyuvm+0xd6>
801083d4:	31 f6                	xor    %esi,%esi
801083d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801083e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801083e3:	89 f0                	mov    %esi,%eax
801083e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801083e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801083eb:	a8 01                	test   $0x1,%al
801083ed:	75 11                	jne    80108400 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801083ef:	83 ec 0c             	sub    $0xc,%esp
801083f2:	68 9c 8f 10 80       	push   $0x80108f9c
801083f7:	e8 84 7f ff ff       	call   80100380 <panic>
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108400:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108407:	c1 ea 0a             	shr    $0xa,%edx
8010840a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108410:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108417:	85 c0                	test   %eax,%eax
80108419:	74 d4                	je     801083ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010841b:	8b 00                	mov    (%eax),%eax
8010841d:	a8 01                	test   $0x1,%al
8010841f:	0f 84 9f 00 00 00    	je     801084c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108425:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108427:	25 ff 0f 00 00       	and    $0xfff,%eax
8010842c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010842f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108435:	e8 46 a2 ff ff       	call   80102680 <kalloc>
8010843a:	89 c3                	mov    %eax,%ebx
8010843c:	85 c0                	test   %eax,%eax
8010843e:	74 64                	je     801084a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108440:	83 ec 04             	sub    $0x4,%esp
80108443:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108449:	68 00 10 00 00       	push   $0x1000
8010844e:	57                   	push   %edi
8010844f:	50                   	push   %eax
80108450:	e8 1b d5 ff ff       	call   80105970 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108455:	58                   	pop    %eax
80108456:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010845c:	5a                   	pop    %edx
8010845d:	ff 75 e4             	push   -0x1c(%ebp)
80108460:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108465:	89 f2                	mov    %esi,%edx
80108467:	50                   	push   %eax
80108468:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010846b:	e8 60 f8 ff ff       	call   80107cd0 <mappages>
80108470:	83 c4 10             	add    $0x10,%esp
80108473:	85 c0                	test   %eax,%eax
80108475:	78 21                	js     80108498 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108477:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010847d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108480:	0f 87 5a ff ff ff    	ja     801083e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108486:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010848c:	5b                   	pop    %ebx
8010848d:	5e                   	pop    %esi
8010848e:	5f                   	pop    %edi
8010848f:	5d                   	pop    %ebp
80108490:	c3                   	ret    
80108491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108498:	83 ec 0c             	sub    $0xc,%esp
8010849b:	53                   	push   %ebx
8010849c:	e8 1f a0 ff ff       	call   801024c0 <kfree>
      goto bad;
801084a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801084a4:	83 ec 0c             	sub    $0xc,%esp
801084a7:	ff 75 e0             	push   -0x20(%ebp)
801084aa:	e8 91 fd ff ff       	call   80108240 <freevm>
  return 0;
801084af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801084b6:	83 c4 10             	add    $0x10,%esp
}
801084b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084bf:	5b                   	pop    %ebx
801084c0:	5e                   	pop    %esi
801084c1:	5f                   	pop    %edi
801084c2:	5d                   	pop    %ebp
801084c3:	c3                   	ret    
      panic("copyuvm: page not present");
801084c4:	83 ec 0c             	sub    $0xc,%esp
801084c7:	68 b6 8f 10 80       	push   $0x80108fb6
801084cc:	e8 af 7e ff ff       	call   80100380 <panic>
801084d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084df:	90                   	nop

801084e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801084e0:	55                   	push   %ebp
801084e1:	89 e5                	mov    %esp,%ebp
801084e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801084e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801084e9:	89 c1                	mov    %eax,%ecx
801084eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801084ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801084f1:	f6 c2 01             	test   $0x1,%dl
801084f4:	0f 84 00 01 00 00    	je     801085fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801084fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801084fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108503:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108504:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108509:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108510:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108512:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108517:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010851a:	05 00 00 00 80       	add    $0x80000000,%eax
8010851f:	83 fa 05             	cmp    $0x5,%edx
80108522:	ba 00 00 00 00       	mov    $0x0,%edx
80108527:	0f 45 c2             	cmovne %edx,%eax
}
8010852a:	c3                   	ret    
8010852b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010852f:	90                   	nop

80108530 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108530:	55                   	push   %ebp
80108531:	89 e5                	mov    %esp,%ebp
80108533:	57                   	push   %edi
80108534:	56                   	push   %esi
80108535:	53                   	push   %ebx
80108536:	83 ec 0c             	sub    $0xc,%esp
80108539:	8b 75 14             	mov    0x14(%ebp),%esi
8010853c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010853f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108542:	85 f6                	test   %esi,%esi
80108544:	75 51                	jne    80108597 <copyout+0x67>
80108546:	e9 a5 00 00 00       	jmp    801085f0 <copyout+0xc0>
8010854b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010854f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108550:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108556:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010855c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108562:	74 75                	je     801085d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108564:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108566:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108569:	29 c3                	sub    %eax,%ebx
8010856b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108571:	39 f3                	cmp    %esi,%ebx
80108573:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108576:	29 f8                	sub    %edi,%eax
80108578:	83 ec 04             	sub    $0x4,%esp
8010857b:	01 c1                	add    %eax,%ecx
8010857d:	53                   	push   %ebx
8010857e:	52                   	push   %edx
8010857f:	51                   	push   %ecx
80108580:	e8 eb d3 ff ff       	call   80105970 <memmove>
    len -= n;
    buf += n;
80108585:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108588:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010858e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108591:	01 da                	add    %ebx,%edx
  while(len > 0){
80108593:	29 de                	sub    %ebx,%esi
80108595:	74 59                	je     801085f0 <copyout+0xc0>
  if(*pde & PTE_P){
80108597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010859a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010859c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010859e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801085a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801085a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801085aa:	f6 c1 01             	test   $0x1,%cl
801085ad:	0f 84 4e 00 00 00    	je     80108601 <copyout.cold>
  return &pgtab[PTX(va)];
801085b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801085bb:	c1 eb 0c             	shr    $0xc,%ebx
801085be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801085c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801085cb:	89 d9                	mov    %ebx,%ecx
801085cd:	83 e1 05             	and    $0x5,%ecx
801085d0:	83 f9 05             	cmp    $0x5,%ecx
801085d3:	0f 84 77 ff ff ff    	je     80108550 <copyout+0x20>
  }
  return 0;
}
801085d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801085dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801085e1:	5b                   	pop    %ebx
801085e2:	5e                   	pop    %esi
801085e3:	5f                   	pop    %edi
801085e4:	5d                   	pop    %ebp
801085e5:	c3                   	ret    
801085e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085ed:	8d 76 00             	lea    0x0(%esi),%esi
801085f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801085f3:	31 c0                	xor    %eax,%eax
}
801085f5:	5b                   	pop    %ebx
801085f6:	5e                   	pop    %esi
801085f7:	5f                   	pop    %edi
801085f8:	5d                   	pop    %ebp
801085f9:	c3                   	ret    

801085fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801085fa:	a1 00 00 00 00       	mov    0x0,%eax
801085ff:	0f 0b                	ud2    

80108601 <copyout.cold>:
80108601:	a1 00 00 00 00       	mov    0x0,%eax
80108606:	0f 0b                	ud2    
