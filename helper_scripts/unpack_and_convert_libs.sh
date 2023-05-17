
# In the A/UX side...
find . -name \*.a -print | sed 's/^/mkdir /' | sed 's/$/_extracted/' | sh
find . -name \*.a -print | sed 's/^/FN=/' | sed 's+$+ export FN; cd ${FN}_extracted; ar x ../`basename ${FN}`; cd '`pwd`'+' | sh
pax -w -p . | dd bs=16384 /dev/rdsk/c1d0s31

# In the Linux side...
tar -czf data_libs.tar.gz --format ustar @data_libs.img
mkdir data_libs
cd data_libs
tar -xf ../data_libs.tar.gz
rm -r ./usr/lib/libmac_s.a_extracted ./usr/lib/libX11_s.a_extracted ./lib/libc_s.a_extracted
find . -iname .DS_Store -delete
find . -iname ._.DS_Store -delete
rm ./usr/lib/libXext.a_extracted/._extutil.o
mv ./usr/lib/librpcsvc.a_extracted/bootparam_xdr. ./usr/lib/librpcsvc.a_extracted/bootparam_xdr.o
mv ./usr/lib/libpaps.a_extracted/paps_papwrite. ./usr/lib/libpaps.a_extracted/paps_papwrite.o
mv ./usr/lib/libpaps.a_extracted/paps_syscalls. ./usr/lib/libpaps.a_extracted/paps_syscalls.o
mv ./usr/lib/libpaps.a_extracted/paps_mem_alloc ./usr/lib/libpaps.a_extracted/paps_mem_alloc.o
mv ./usr/lib/libpaps.a_extracted/paps_papclose. ./usr/lib/libpaps.a_extracted/paps_papclose.o
mv ./usr/lib/libp/librpcsvc.a_extracted/bootparam_xdr. ./usr/lib/libp/librpcsvc.a_extracted/bootparam_xdr.o
find . -iname \*.o | xargs rename -e 's/\.o$/.coff.o/'
find . -iname \*.coff.o -exec /Volumes/public_share/binutils_old/pfx/bin/m68k-apple-aux-objcopy -I coff-m68k-aux -O elf32-m68k {} {}.elf.o \;
find . -iname \*.coff.o -delete
find . -iname \*.elf.o | xargs rename  -e 's/\.coff\.o\.elf\.o$/.o/'
find . -iname \*.a_extracted | parallel echo {} \&\& cd {} \&\& ar rcs ../{/.}.a \*.o
