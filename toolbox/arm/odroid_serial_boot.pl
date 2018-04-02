
                   $exp->send("\r\n\r\n");

               } ],
             [ qr/odroidc2\#/ => sub {
                   my $exp = shift;
                   say "Got shell";
               } ],
             [ qr/Starting kernel/ => sub {
                   my $exp = shift;
                   say "Starting kernel, script failed";
                   exit 0;
               } ],
         );
my @init = (
    'setenv bootargs "coherent_pool=2M root=UUID=e139ce78-9841-40fe-8823-96a304a09859 rootwait ro consol
eblank=0 console=ttyS0,115200n8 console=tty0 no_console_suspend  hdmimode=1080p60hz m_bpp=32 vout= fsck.repair=yes ele
vator=noop disablehpd=true  max_freq=1536 maxcpus=4 monitor_onoff=false disableuhs=false mmc_removable=true usbmultica
m=false net.ifnames=0"',
    'setenv loadaddr "0x11000000"',
    'setenv dtb_loadaddr "0x1000000"',
    'setenv initrd_loadaddr "0x13000000"',
    'fatload mmc 0:1 ${initrd_loadaddr} uInitrd',
    'fatload mmc 0:1 ${loadaddr} Image',
    'fatload mmc 0:1 ${dtb_loadaddr} meson64_odroidc2.dtb',
    'fdt addr ${dtb_loadaddr}',
    'fdt rm /timer',
    'fdt rm /reserved-memory; fdt rm /aocec',
    'fdt rm /meson-fb; fdt rm /amhdmitx; fdt rm /picdec; fdt rm /ppmgr',
    'fdt rm /meson-vout; fdt rm /mesonstream; fdt rm /meson-fb',
    'fdt rm /deinterlace; fdt rm /codec_mm',
    'fdt rm /aocec',
    'booti ${loadaddr} ${initrd_loadaddr} ${dtb_loadaddr}',
);
say "Starting init";
for my $line(@init) {
    $exp->send("$line\n");
    $exp->expect($timeout,
             [ qr/odroid.*\#/ => sub {
                   my $exp = shift;
                   say "Sent $line";
                   say "before: " . $exp->before;
               } ],
             );
}
say "boot init finished";
$exp->expect($timeout,
             [ qr/Started Load Kernel Modules/ => sub {
                   my $exp = shift;
                   say "Linux booted";
               } ],
         );





# end at Started Load Kernel Modules

sub init_config {
    my $PortObj = new Device::SerialPort ($port, $quiet) #, $lockfile)
        || die "Can't open $port: $!\n";

    $PortObj->baudrate(115200);
    $PortObj->parity("none");
    $PortObj->handshake("none");
    $PortObj->databits(8);
    $PortObj->stopbits(1);        # POSIX does not support 1.5 stopbits
    $PortObj->save($cfgfile);
}
