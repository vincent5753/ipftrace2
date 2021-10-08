--
-- SPDX-License-Identifier: GPL-2.0-only
-- Copyright (C) 2021-present Yutaro Hayakawa
--
-- An example module provides the extra output
-- to track TSO/GSO or LRO/GRO behavior. Only
-- works when your kernel is compiled with
-- NET_SKBUFF_DATA_USES_OFFSET=y
--
api_version = 1

GSO_FLAGS = {
  [ 1 << 0 ]  = "tcpv4",
  [ 1 << 1 ]  = "dodgy",
  [ 1 << 2 ]  = "tcp-ecn",
  [ 1 << 3 ]  = "tcp-fixedid",
  [ 1 << 4 ]  = "tcpv6",
  [ 1 << 5 ]  = "fcoe",
  [ 1 << 6 ]  = "gre",
  [ 1 << 7 ]  = "gre-csum",
  [ 1 << 8 ]  = "ipxip4",
  [ 1 << 9 ]  = "ipxip6",
  [ 1 << 10 ] = "udp-tunnel",
  [ 1 << 11 ] = "udp-tunnel-csum",
  [ 1 << 12 ] = "partial",
  [ 1 << 13 ] = "tunnel-remcsum",
  [ 1 << 14 ] = "sctp",
  [ 1 << 15 ] = "esp",
  [ 1 << 16 ] = "udp",
  [ 1 << 17 ] = "udp-l4",
  [ 1 << 18 ] = "flaglist",
}

function flags2str(flags)
  ret = ""
  is_first = true
  for k, v in pairs(GSO_FLAGS) do
    if flags & k ~=  0 then
      if not is_first then
        ret = ret.."|"..v
      else
        ret = ret..v
        is_first = false
      end
    end
  end
  if ret == "" then
    ret = "none"
  end
  return ret
end

function emit()
  -- Generated with: od -An -tx1 -v gso.bpf.o | sed "s/ /\\\x/g" | tr -d "\n"
  return "\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\xf7\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\x1b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x40\x00\x0f\x00\x0d\x00\xbf\x36\x00\x00\x00\x00\x00\x00\xbf\x28\x00\x00\x00\x00\x00\x00\xb7\x01\x00\x00\x08\x00\x00\x00\xbf\x83\x00\x00\x00\x00\x00\x00\x0f\x13\x00\x00\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x08\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\xb7\x01\x00\x00\x10\x00\x00\x00\xbf\x83\x00\x00\x00\x00\x00\x00\x0f\x13\x00\x00\x00\x00\x00\x00\x79\xa7\xf8\xff\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x04\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\xb7\x01\x00\x00\x00\x00\x00\x00\x0f\x18\x00\x00\x00\x00\x00\x00\x61\xa9\xf8\xff\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x04\x00\x00\x00\xbf\x83\x00\x00\x00\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\x61\xa1\xf8\xff\x00\x00\x00\x00\x63\x16\x00\x00\x00\x00\x00\x00\x0f\x97\x00\x00\x00\x00\x00\x00\xb7\x01\x00\x00\x00\x00\x00\x00\xbf\x73\x00\x00\x00\x00\x00\x00\x0f\x13\x00\x00\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x02\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\x69\xa1\xf8\xff\x00\x00\x00\x00\x6b\x16\x04\x00\x00\x00\x00\x00\xb7\x01\x00\x00\x02\x00\x00\x00\xbf\x73\x00\x00\x00\x00\x00\x00\x0f\x13\x00\x00\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x02\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\x69\xa1\xf8\xff\x00\x00\x00\x00\x6b\x16\x06\x00\x00\x00\x00\x00\xb7\x01\x00\x00\x04\x00\x00\x00\x0f\x17\x00\x00\x00\x00\x00\x00\xbf\xa1\x00\x00\x00\x00\x00\x00\x07\x01\x00\x00\xf8\xff\xff\xff\xb7\x02\x00\x00\x04\x00\x00\x00\xbf\x73\x00\x00\x00\x00\x00\x00\x85\x00\x00\x00\x71\x00\x00\x00\x61\xa1\xf8\xff\x00\x00\x00\x00\x63\x16\x08\x00\x00\x00\x00\x00\xb7\x00\x00\x00\x00\x00\x00\x00\x95\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00\x01\x00\x51\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x00\x00\x00\x00\x00\x00\x00\x01\x00\x52\x28\x00\x00\x00\x00\x00\x00\x00\x98\x00\x00\x00\x00\x00\x00\x00\x01\x00\x58\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x01\x00\x53\x28\x00\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x00\x00\x00\x00\x01\x00\x56\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x00\x00\x00\x00\x00\x00\x00\x68\x00\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\x68\x00\x00\x00\x00\x00\x00\x00\xe0\x00\x00\x00\x00\x00\x00\x00\x01\x00\x57\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x68\x00\x00\x00\x00\x00\x00\x00\xa0\x00\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x68\x00\x00\x00\x00\x00\x00\x00\xe0\x00\x00\x00\x00\x00\x00\x00\x01\x00\x57\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x00\x00\x00\x00\x00\x00\x00\xd0\x00\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\xd0\x00\x00\x00\x00\x00\x00\x00\xe8\x00\x00\x00\x00\x00\x00\x00\x01\x00\x51\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x00\x00\x00\x00\x00\x00\x00\x80\x01\x00\x00\x00\x00\x00\x00\x01\x00\x57\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\x00\x00\x00\x00\x00\x00\x00\x20\x01\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\x20\x01\x00\x00\x00\x00\x00\x00\x30\x01\x00\x00\x00\x00\x00\x00\x01\x00\x51\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00\x68\x01\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\x68\x01\x00\x00\x00\x00\x00\x00\x78\x01\x00\x00\x00\x00\x00\x00\x01\x00\x51\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x01\x00\x00\x00\x00\x00\x00\xb0\x01\x00\x00\x00\x00\x00\x00\x02\x00\x7a\x00\xb0\x01\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x00\x00\x00\x00\x01\x00\x51\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x11\x01\x25\x0e\x13\x05\x03\x0e\x10\x17\x1b\x0e\x11\x01\x12\x06\x00\x00\x02\x34\x00\x03\x0e\x49\x13\x3a\x0b\x3b\x05\x00\x00\x03\x0f\x00\x49\x13\x00\x00\x04\x15\x01\x49\x13\x27\x19\x00\x00\x05\x05\x00\x49\x13\x00\x00\x06\x24\x00\x03\x0e\x3e\x0b\x0b\x0b\x00\x00\x07\x0f\x00\x00\x00\x08\x16\x00\x49\x13\x03\x0e\x3a\x0b\x3b\x0b\x00\x00\x09\x26\x00\x00\x00\x0a\x13\x01\x03\x0e\x0b\x0b\x3a\x0b\x3b\x0b\x00\x00\x0b\x0d\x00\x03\x0e\x49\x13\x3a\x0b\x3b\x0b\x38\x0b\x00\x00\x0c\x2e\x01\x11\x01\x12\x06\x40\x18\x97\x42\x19\x03\x0e\x3a\x0b\x3b\x0b\x27\x19\x49\x13\x3f\x19\x00\x00\x0d\x05\x00\x02\x17\x03\x0e\x3a\x0b\x3b\x0b\x49\x13\x00\x00\x0e\x34\x00\x02\x18\x03\x0e\x3a\x0b\x3b\x0b\x49\x13\x00\x00\x0f\x34\x00\x02\x17\x03\x0e\x3a\x0b\x3b\x0b\x49\x13\x00\x00\x10\x34\x00\x03\x0e\x3a\x0b\x3b\x0b\x49\x13\x00\x00\x11\x0b\x01\x11\x01\x12\x06\x00\x00\x00\xac\x03\x00\x00\x04\x00\x00\x00\x00\x00\x08\x01\x00\x00\x00\x00\x0c\x00\x32\x00\x00\x00\x00\x00\x00\x00\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x02\x4d\x00\x00\x00\x36\x00\x00\x00\x02\xba\x0a\x03\x3b\x00\x00\x00\x04\x50\x00\x00\x00\x05\x57\x00\x00\x00\x05\x58\x00\x00\x00\x05\x6a\x00\x00\x00\x00\x06\x63\x00\x00\x00\x05\x08\x07\x08\x63\x00\x00\x00\x79\x00\x00\x00\x01\x1b\x06\x6c\x00\x00\x00\x07\x04\x03\x6f\x00\x00\x00\x09\x03\x75\x00\x00\x00\x0a\xd5\x00\x00\x00\x0c\x03\x0b\x0b\x7f\x00\x00\x00\x63\x00\x00\x00\x03\x0c\x00\x0b\x83\x00\x00\x00\xae\x00\x00\x00\x03\x0d\x04\x0b\xaf\x00\x00\x00\xae\x00\x00\x00\x03\x0e\x06\x0b\xb8\x00\x00\x00\xcb\x00\x00\x00\x03\x0f\x08\x00\x08\xb9\x00\x00\x00\xa6\x00\x00\x00\x05\x19\x08\xc4\x00\x00\x00\x9b\x00\x00\x00\x04\x28\x06\x8c\x00\x00\x00\x07\x02\x08\xd6\x00\x00\x00\xcc\x00\x00\x00\x05\x1a\x08\x63\x00\x00\x00\xc1\x00\x00\x00\x04\x2a\x03\xe6\x00\x00\x00\x0a\xf5\x00\x00\x00\x18\x03\x12\x0b\x7f\x00\x00\x00\x63\x00\x00\x00\x03\x13\x00\x0b\xde\x00\x00\x00\x13\x01\x00\x00\x03\x14\x08\x0b\xf1\x00\x00\x00\x63\x00\x00\x00\x03\x15\x10\x00\x03\x18\x01\x00\x00\x06\xe3\x00\x00\x00\x08\x01\x03\x24\x01\x00\x00\x0a\xfd\x00\x00\x00\x08\x03\x18\x0b\x83\x00\x00\x00\xae\x00\x00\x00\x03\x19\x00\x0b\xaf\x00\x00\x00\xae\x00\x00\x00\x03\x1a\x02\x0b\xb8\x00\x00\x00\xcb\x00\x00\x00\x03\x1b\x04\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x01\x5a\x0d\x01\x00\x00\x03\x1f\x7c\x02\x00\x00\x0d\x00\x00\x00\x00\x18\x01\x00\x00\x03\x1f\x83\x02\x00\x00\x0d\x23\x00\x00\x00\x8e\x01\x00\x00\x03\x1f\xe1\x00\x00\x00\x0d\x59\x00\x00\x00\x92\x01\x00\x00\x03\x1f\x94\x03\x00\x00\x0e\x01\x56\xad\x01\x00\x00\x03\x24\x70\x00\x00\x00\x0f\xea\x00\x00\x00\xde\x00\x00\x00\x03\x22\x13\x01\x00\x00\x10\xf1\x00\x00\x00\x03\x21\x63\x00\x00\x00\x0f\x44\x01\x00\x00\xb2\x01\x00\x00\x03\x23\x1f\x01\x00\x00\x11\x38\x00\x00\x00\x00\x00\x00\x00\x38\x00\x00\x00\x0f\x8f\x00\x00\x00\xa9\x01\x00\x00\x03\x26\x13\x01\x00\x00\x00\x11\x78\x00\x00\x00\x00\x00\x00\x00\x30\x00\x00\x00\x0f\xc6\x00\x00\x00\xa9\x01\x00\x00\x03\x27\x63\x00\x00\x00\x00\x11\xb0\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x0f\x0d\x01\x00\x00\xa9\x01\x00\x00\x03\x2a\x63\x00\x00\x00\x00\x11\x08\x01\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x0f\x67\x01\x00\x00\xa9\x01\x00\x00\x03\x2b\xae\x00\x00\x00\x00\x11\x50\x01\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x0f\x9e\x01\x00\x00\xa9\x01\x00\x00\x03\x2c\xae\x00\x00\x00\x00\x11\x90\x01\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x0f\xd5\x01\x00\x00\xa9\x01\x00\x00\x03\x2d\xcb\x00\x00\x00\x00\x00\x06\x14\x01\x00\x00\x05\x04\x03\x88\x02\x00\x00\x0a\x86\x01\x00\x00\xa8\x06\x29\x0b\x1c\x01\x00\x00\x8d\x03\x00\x00\x06\x2e\x00\x0b\x32\x01\x00\x00\x8d\x03\x00\x00\x06\x2f\x08\x0b\x36\x01\x00\x00\x8d\x03\x00\x00\x06\x30\x10\x0b\x3a\x01\x00\x00\x8d\x03\x00\x00\x06\x31\x18\x0b\x3e\x01\x00\x00\x8d\x03\x00\x00\x06\x32\x20\x0b\x42\x01\x00\x00\x8d\x03\x00\x00\x06\x33\x28\x0b\x46\x01\x00\x00\x8d\x03\x00\x00\x06\x35\x30\x0b\x4a\x01\x00\x00\x8d\x03\x00\x00\x06\x36\x38\x0b\x4e\x01\x00\x00\x8d\x03\x00\x00\x06\x37\x40\x0b\x51\x01\x00\x00\x8d\x03\x00\x00\x06\x38\x48\x0b\x54\x01\x00\x00\x8d\x03\x00\x00\x06\x39\x50\x0b\x58\x01\x00\x00\x8d\x03\x00\x00\x06\x3a\x58\x0b\x5c\x01\x00\x00\x8d\x03\x00\x00\x06\x3b\x60\x0b\x60\x01\x00\x00\x8d\x03\x00\x00\x06\x3c\x68\x0b\x64\x01\x00\x00\x8d\x03\x00\x00\x06\x3d\x70\x0b\x68\x01\x00\x00\x8d\x03\x00\x00\x06\x42\x78\x0b\x71\x01\x00\x00\x8d\x03\x00\x00\x06\x44\x80\x0b\x75\x01\x00\x00\x8d\x03\x00\x00\x06\x45\x88\x0b\x78\x01\x00\x00\x8d\x03\x00\x00\x06\x46\x90\x0b\x7f\x01\x00\x00\x8d\x03\x00\x00\x06\x47\x98\x0b\x83\x01\x00\x00\x8d\x03\x00\x00\x06\x48\xa0\x00\x06\x20\x01\x00\x00\x07\x08\x03\x99\x03\x00\x00\x08\xa4\x03\x00\x00\xa1\x01\x00\x00\x05\x18\x08\x18\x01\x00\x00\x97\x01\x00\x00\x04\x26\x00\x63\x6c\x61\x6e\x67\x20\x76\x65\x72\x73\x69\x6f\x6e\x20\x31\x32\x2e\x30\x2e\x30\x20\x28\x46\x65\x64\x6f\x72\x61\x20\x31\x32\x2e\x30\x2e\x30\x2d\x30\x2e\x33\x2e\x72\x63\x31\x2e\x66\x63\x33\x34\x29\x00\x67\x73\x6f\x2e\x62\x70\x66\x2e\x63\x00\x2f\x76\x61\x67\x72\x61\x6e\x74\x2f\x65\x78\x61\x6d\x70\x6c\x65\x00\x62\x70\x66\x5f\x70\x72\x6f\x62\x65\x5f\x72\x65\x61\x64\x5f\x6b\x65\x72\x6e\x65\x6c\x00\x6c\x6f\x6e\x67\x20\x69\x6e\x74\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\x00\x5f\x5f\x75\x33\x32\x00\x6c\x65\x6e\x00\x67\x73\x6f\x5f\x73\x69\x7a\x65\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x73\x68\x6f\x72\x74\x00\x5f\x5f\x75\x69\x6e\x74\x31\x36\x5f\x74\x00\x75\x69\x6e\x74\x31\x36\x5f\x74\x00\x67\x73\x6f\x5f\x73\x65\x67\x73\x00\x67\x73\x6f\x5f\x74\x79\x70\x65\x00\x5f\x5f\x75\x69\x6e\x74\x33\x32\x5f\x74\x00\x75\x69\x6e\x74\x33\x32\x5f\x74\x00\x67\x73\x6f\x5f\x69\x6e\x66\x6f\x00\x68\x65\x61\x64\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x63\x68\x61\x72\x00\x65\x6e\x64\x00\x73\x6b\x5f\x62\x75\x66\x66\x00\x73\x6b\x62\x5f\x73\x68\x61\x72\x65\x64\x5f\x69\x6e\x66\x6f\x00\x6d\x6f\x64\x75\x6c\x65\x00\x69\x6e\x74\x00\x63\x74\x78\x00\x72\x31\x35\x00\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\x00\x72\x31\x34\x00\x72\x31\x33\x00\x72\x31\x32\x00\x72\x62\x70\x00\x72\x62\x78\x00\x72\x31\x31\x00\x72\x31\x30\x00\x72\x39\x00\x72\x38\x00\x72\x61\x78\x00\x72\x63\x78\x00\x72\x64\x78\x00\x72\x73\x69\x00\x72\x64\x69\x00\x6f\x72\x69\x67\x5f\x72\x61\x78\x00\x72\x69\x70\x00\x63\x73\x00\x65\x66\x6c\x61\x67\x73\x00\x72\x73\x70\x00\x73\x73\x00\x70\x74\x5f\x72\x65\x67\x73\x00\x73\x6b\x62\x00\x64\x61\x74\x61\x00\x5f\x5f\x75\x69\x6e\x74\x38\x5f\x74\x00\x75\x69\x6e\x74\x38\x5f\x74\x00\x5f\x5f\x72\x00\x69\x6e\x66\x6f\x00\x73\x68\x69\x6e\x66\x6f\x00\x9f\xeb\x01\x00\x18\x00\x00\x00\x00\x00\x00\x00\x60\x02\x00\x00\x60\x02\x00\x00\xe5\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x02\x00\x00\x00\x01\x00\x00\x00\x15\x00\x00\x04\xa8\x00\x00\x00\x09\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x0d\x00\x00\x00\x03\x00\x00\x00\x40\x00\x00\x00\x11\x00\x00\x00\x03\x00\x00\x00\x80\x00\x00\x00\x15\x00\x00\x00\x03\x00\x00\x00\xc0\x00\x00\x00\x19\x00\x00\x00\x03\x00\x00\x00\x00\x01\x00\x00\x1d\x00\x00\x00\x03\x00\x00\x00\x40\x01\x00\x00\x21\x00\x00\x00\x03\x00\x00\x00\x80\x01\x00\x00\x25\x00\x00\x00\x03\x00\x00\x00\xc0\x01\x00\x00\x29\x00\x00\x00\x03\x00\x00\x00\x00\x02\x00\x00\x2c\x00\x00\x00\x03\x00\x00\x00\x40\x02\x00\x00\x2f\x00\x00\x00\x03\x00\x00\x00\x80\x02\x00\x00\x33\x00\x00\x00\x03\x00\x00\x00\xc0\x02\x00\x00\x37\x00\x00\x00\x03\x00\x00\x00\x00\x03\x00\x00\x3b\x00\x00\x00\x03\x00\x00\x00\x40\x03\x00\x00\x3f\x00\x00\x00\x03\x00\x00\x00\x80\x03\x00\x00\x43\x00\x00\x00\x03\x00\x00\x00\xc0\x03\x00\x00\x4c\x00\x00\x00\x03\x00\x00\x00\x00\x04\x00\x00\x50\x00\x00\x00\x03\x00\x00\x00\x40\x04\x00\x00\x53\x00\x00\x00\x03\x00\x00\x00\x80\x04\x00\x00\x5a\x00\x00\x00\x03\x00\x00\x00\xc0\x04\x00\x00\x5e\x00\x00\x00\x03\x00\x00\x00\x00\x05\x00\x00\x61\x00\x00\x00\x00\x00\x00\x01\x08\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x05\x00\x00\x00\x73\x00\x00\x00\x03\x00\x00\x04\x18\x00\x00\x00\x7b\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x7f\x00\x00\x00\x07\x00\x00\x00\x40\x00\x00\x00\x84\x00\x00\x00\x06\x00\x00\x00\x80\x00\x00\x00\x88\x00\x00\x00\x00\x00\x00\x01\x04\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x08\x00\x00\x00\x95\x00\x00\x00\x00\x00\x00\x01\x01\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x0a\x00\x00\x00\xa3\x00\x00\x00\x00\x00\x00\x08\x0b\x00\x00\x00\xab\x00\x00\x00\x00\x00\x00\x08\x08\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x0d\x0d\x00\x00\x00\xb5\x00\x00\x00\x01\x00\x00\x00\xb9\x00\x00\x00\x04\x00\x00\x00\xbd\x00\x00\x00\x09\x00\x00\x00\xc2\x00\x00\x00\x00\x00\x00\x01\x04\x00\x00\x00\x20\x00\x00\x01\xc6\x00\x00\x00\x01\x00\x00\x0c\x0c\x00\x00\x00\xdb\x01\x00\x00\x03\x00\x00\x04\x08\x00\x00\x00\xeb\x01\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\xf4\x01\x00\x00\x10\x00\x00\x00\x10\x00\x00\x00\xfd\x01\x00\x00\x13\x00\x00\x00\x20\x00\x00\x00\x06\x02\x00\x00\x00\x00\x00\x08\x11\x00\x00\x00\x0f\x02\x00\x00\x00\x00\x00\x08\x12\x00\x00\x00\x1a\x02\x00\x00\x00\x00\x00\x01\x02\x00\x00\x00\x10\x00\x00\x00\x29\x02\x00\x00\x00\x00\x00\x08\x14\x00\x00\x00\x32\x02\x00\x00\x00\x00\x00\x08\x06\x00\x00\x00\x00\x70\x74\x5f\x72\x65\x67\x73\x00\x72\x31\x35\x00\x72\x31\x34\x00\x72\x31\x33\x00\x72\x31\x32\x00\x72\x62\x70\x00\x72\x62\x78\x00\x72\x31\x31\x00\x72\x31\x30\x00\x72\x39\x00\x72\x38\x00\x72\x61\x78\x00\x72\x63\x78\x00\x72\x64\x78\x00\x72\x73\x69\x00\x72\x64\x69\x00\x6f\x72\x69\x67\x5f\x72\x61\x78\x00\x72\x69\x70\x00\x63\x73\x00\x65\x66\x6c\x61\x67\x73\x00\x72\x73\x70\x00\x73\x73\x00\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\x00\x73\x6b\x5f\x62\x75\x66\x66\x00\x6c\x65\x6e\x00\x68\x65\x61\x64\x00\x65\x6e\x64\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x63\x68\x61\x72\x00\x75\x69\x6e\x74\x38\x5f\x74\x00\x5f\x5f\x75\x69\x6e\x74\x38\x5f\x74\x00\x63\x74\x78\x00\x73\x6b\x62\x00\x64\x61\x74\x61\x00\x69\x6e\x74\x00\x6d\x6f\x64\x75\x6c\x65\x00\x2e\x74\x65\x78\x74\x00\x2f\x76\x61\x67\x72\x61\x6e\x74\x2f\x65\x78\x61\x6d\x70\x6c\x65\x2f\x67\x73\x6f\x2e\x62\x70\x66\x2e\x63\x00\x6d\x6f\x64\x75\x6c\x65\x28\x73\x74\x72\x75\x63\x74\x20\x70\x74\x5f\x72\x65\x67\x73\x20\x2a\x63\x74\x78\x2c\x20\x73\x74\x72\x75\x63\x74\x20\x73\x6b\x5f\x62\x75\x66\x66\x20\x2a\x73\x6b\x62\x2c\x20\x75\x69\x6e\x74\x38\x5f\x74\x20\x64\x61\x74\x61\x5b\x36\x34\x5d\x29\x00\x30\x3a\x31\x00\x20\x20\x68\x65\x61\x64\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x6b\x62\x2c\x20\x68\x65\x61\x64\x29\x3b\x00\x30\x3a\x32\x00\x20\x20\x65\x6e\x64\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x6b\x62\x2c\x20\x65\x6e\x64\x29\x3b\x00\x30\x3a\x30\x00\x20\x20\x69\x6e\x66\x6f\x2d\x3e\x6c\x65\x6e\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x6b\x62\x2c\x20\x6c\x65\x6e\x29\x3b\x00\x20\x20\x73\x68\x69\x6e\x66\x6f\x20\x3d\x20\x28\x73\x74\x72\x75\x63\x74\x20\x73\x6b\x62\x5f\x73\x68\x61\x72\x65\x64\x5f\x69\x6e\x66\x6f\x20\x2a\x29\x28\x68\x65\x61\x64\x20\x2b\x20\x65\x6e\x64\x29\x3b\x00\x73\x6b\x62\x5f\x73\x68\x61\x72\x65\x64\x5f\x69\x6e\x66\x6f\x00\x67\x73\x6f\x5f\x73\x69\x7a\x65\x00\x67\x73\x6f\x5f\x73\x65\x67\x73\x00\x67\x73\x6f\x5f\x74\x79\x70\x65\x00\x75\x69\x6e\x74\x31\x36\x5f\x74\x00\x5f\x5f\x75\x69\x6e\x74\x31\x36\x5f\x74\x00\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x73\x68\x6f\x72\x74\x00\x75\x69\x6e\x74\x33\x32\x5f\x74\x00\x5f\x5f\x75\x69\x6e\x74\x33\x32\x5f\x74\x00\x20\x20\x69\x6e\x66\x6f\x2d\x3e\x67\x73\x6f\x5f\x73\x69\x7a\x65\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x68\x69\x6e\x66\x6f\x2c\x20\x67\x73\x6f\x5f\x73\x69\x7a\x65\x29\x3b\x00\x20\x20\x69\x6e\x66\x6f\x2d\x3e\x67\x73\x6f\x5f\x73\x65\x67\x73\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x68\x69\x6e\x66\x6f\x2c\x20\x67\x73\x6f\x5f\x73\x65\x67\x73\x29\x3b\x00\x20\x20\x69\x6e\x66\x6f\x2d\x3e\x67\x73\x6f\x5f\x74\x79\x70\x65\x20\x3d\x20\x42\x50\x46\x5f\x43\x4f\x52\x45\x5f\x52\x45\x41\x44\x28\x73\x68\x69\x6e\x66\x6f\x2c\x20\x67\x73\x6f\x5f\x74\x79\x70\x65\x29\x3b\x00\x20\x20\x72\x65\x74\x75\x72\x6e\x20\x30\x3b\x00\x9f\xeb\x01\x00\x20\x00\x00\x00\x00\x00\x00\x00\x14\x00\x00\x00\x14\x00\x00\x00\x9c\x01\x00\x00\xb0\x01\x00\x00\x6c\x00\x00\x00\x08\x00\x00\x00\xcd\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x0e\x00\x00\x00\x10\x00\x00\x00\xcd\x00\x00\x00\x19\x00\x00\x00\x00\x00\x00\x00\xd3\x00\x00\x00\xee\x00\x00\x00\x00\x7c\x00\x00\x30\x00\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x38\x00\x00\x00\xd3\x00\x00\x00\x35\x01\x00\x00\x0a\x98\x00\x00\x60\x00\x00\x00\xd3\x00\x00\x00\x35\x01\x00\x00\x0a\x98\x00\x00\x70\x00\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x78\x00\x00\x00\xd3\x00\x00\x00\x5c\x01\x00\x00\x09\x9c\x00\x00\x98\x00\x00\x00\xd3\x00\x00\x00\x5c\x01\x00\x00\x09\x9c\x00\x00\xa8\x00\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb0\x00\x00\x00\xd3\x00\x00\x00\x81\x01\x00\x00\x0f\xa8\x00\x00\xc8\x00\x00\x00\xd3\x00\x00\x00\x81\x01\x00\x00\x0f\xa8\x00\x00\xd0\x00\x00\x00\xd3\x00\x00\x00\x81\x01\x00\x00\x0d\xa8\x00\x00\xd8\x00\x00\x00\xd3\x00\x00\x00\xa8\x01\x00\x00\x2c\xa0\x00\x00\x00\x01\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x01\x00\x00\xd3\x00\x00\x00\x3d\x02\x00\x00\x14\xac\x00\x00\x18\x01\x00\x00\xd3\x00\x00\x00\x3d\x02\x00\x00\x14\xac\x00\x00\x20\x01\x00\x00\xd3\x00\x00\x00\x3d\x02\x00\x00\x12\xac\x00\x00\x48\x01\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x01\x00\x00\xd3\x00\x00\x00\x71\x02\x00\x00\x14\xb0\x00\x00\x60\x01\x00\x00\xd3\x00\x00\x00\x71\x02\x00\x00\x14\xb0\x00\x00\x68\x01\x00\x00\xd3\x00\x00\x00\x71\x02\x00\x00\x12\xb0\x00\x00\x88\x01\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x90\x01\x00\x00\xd3\x00\x00\x00\xa5\x02\x00\x00\x14\xb4\x00\x00\xa8\x01\x00\x00\xd3\x00\x00\x00\xa5\x02\x00\x00\x14\xb4\x00\x00\xb0\x01\x00\x00\xd3\x00\x00\x00\xa5\x02\x00\x00\x12\xb4\x00\x00\xb8\x01\x00\x00\xd3\x00\x00\x00\xd9\x02\x00\x00\x03\xbc\x00\x00\x10\x00\x00\x00\xcd\x00\x00\x00\x06\x00\x00\x00\x10\x00\x00\x00\x05\x00\x00\x00\x31\x01\x00\x00\x00\x00\x00\x00\x48\x00\x00\x00\x05\x00\x00\x00\x58\x01\x00\x00\x00\x00\x00\x00\x88\x00\x00\x00\x05\x00\x00\x00\x7d\x01\x00\x00\x00\x00\x00\x00\xe0\x00\x00\x00\x0f\x00\x00\x00\x7d\x01\x00\x00\x00\x00\x00\x00\x28\x01\x00\x00\x0f\x00\x00\x00\x31\x01\x00\x00\x00\x00\x00\x00\x70\x01\x00\x00\x0f\x00\x00\x00\x58\x01\x00\x00\x00\x00\x00\x00\x36\x01\x00\x00\x04\x00\xba\x00\x00\x00\x08\x01\x01\xfb\x0e\x0d\x00\x01\x01\x01\x01\x00\x00\x00\x01\x00\x00\x01\x2f\x75\x73\x72\x2f\x69\x6e\x63\x6c\x75\x64\x65\x2f\x61\x73\x6d\x2d\x67\x65\x6e\x65\x72\x69\x63\x00\x2f\x75\x73\x72\x2f\x69\x6e\x63\x6c\x75\x64\x65\x2f\x62\x70\x66\x00\x2f\x75\x73\x72\x2f\x69\x6e\x63\x6c\x75\x64\x65\x2f\x62\x69\x74\x73\x00\x2f\x75\x73\x72\x2f\x69\x6e\x63\x6c\x75\x64\x65\x2f\x61\x73\x6d\x00\x00\x69\x6e\x74\x2d\x6c\x6c\x36\x34\x2e\x68\x00\x01\x00\x00\x62\x70\x66\x5f\x68\x65\x6c\x70\x65\x72\x5f\x64\x65\x66\x73\x2e\x68\x00\x02\x00\x00\x67\x73\x6f\x2e\x62\x70\x66\x2e\x63\x00\x00\x00\x00\x74\x79\x70\x65\x73\x2e\x68\x00\x03\x00\x00\x73\x74\x64\x69\x6e\x74\x2d\x75\x69\x6e\x74\x6e\x2e\x68\x00\x03\x00\x00\x70\x74\x72\x61\x63\x65\x2e\x68\x00\x04\x00\x00\x00\x04\x03\x00\x09\x02\x00\x00\x00\x00\x00\x00\x00\x00\x03\x1f\x01\x0a\x03\x60\x66\x05\x0a\x03\x26\x20\x06\x03\x5a\x2e\x03\x26\x3c\x03\x5a\x20\x05\x09\x06\x03\x27\x2e\x06\x03\x59\x2e\x03\x27\x2e\x03\x59\x20\x05\x0f\x06\x03\x2a\x2e\x06\x3c\x05\x0d\x20\x05\x2c\x06\x1e\x06\x03\x58\x20\x05\x14\x06\x03\x2b\x58\x06\x2e\x05\x12\x20\x03\x55\x2e\x05\x14\x06\x03\x2c\x4a\x06\x2e\x05\x12\x20\x03\x54\x2e\x05\x14\x06\x03\x2d\x3c\x06\x3c\x05\x12\x20\x05\x03\x06\x22\x02\x02\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6d\x00\x00\x00\x04\x00\xf1\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5b\x00\x00\x00\x12\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x04\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x12\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x16\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x06\x00\x00\x00\x1a\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x1e\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x2b\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x51\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x5d\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x64\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x76\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x7e\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x8a\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x96\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xa2\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xb3\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xbe\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xc5\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xd0\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xdb\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xe7\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xef\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xfb\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x07\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x19\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x25\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x2d\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x39\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x45\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x52\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x60\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x6b\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x6f\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x7a\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x7e\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x89\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x8d\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x9a\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xa5\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\xa9\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xb4\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xbf\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\xc3\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xce\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\xdb\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\xdf\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xeb\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\xf8\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\xfc\x01\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x15\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x19\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x25\x02\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x32\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x36\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x42\x02\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x4f\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x53\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x5f\x02\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x6c\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x03\x00\x00\x00\x70\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x7d\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x89\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x91\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x9d\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xa9\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xb5\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xc1\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xcd\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xd9\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xe5\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xf1\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xfd\x02\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x09\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x15\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x21\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x2d\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x39\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x45\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x51\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x5d\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x69\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x75\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x81\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x8e\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x9e\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\xa9\x03\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x05\x00\x00\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x50\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x60\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x70\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xa0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xc0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xd0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xe0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x10\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x20\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x30\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x50\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x60\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x70\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x80\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x90\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xa0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xb0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xc0\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xdc\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xec\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xfc\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x0c\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x1c\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x2c\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xc9\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x00\x2e\x64\x65\x62\x75\x67\x5f\x61\x62\x62\x72\x65\x76\x00\x2e\x74\x65\x78\x74\x00\x2e\x72\x65\x6c\x2e\x42\x54\x46\x2e\x65\x78\x74\x00\x2e\x64\x65\x62\x75\x67\x5f\x73\x74\x72\x00\x2e\x72\x65\x6c\x2e\x64\x65\x62\x75\x67\x5f\x69\x6e\x66\x6f\x00\x2e\x6c\x6c\x76\x6d\x5f\x61\x64\x64\x72\x73\x69\x67\x00\x2e\x72\x65\x6c\x2e\x64\x65\x62\x75\x67\x5f\x6c\x69\x6e\x65\x00\x6d\x6f\x64\x75\x6c\x65\x00\x2e\x64\x65\x62\x75\x67\x5f\x6c\x6f\x63\x00\x67\x73\x6f\x2e\x62\x70\x66\x2e\x63\x00\x2e\x73\x74\x72\x74\x61\x62\x00\x2e\x73\x79\x6d\x74\x61\x62\x00\x2e\x42\x54\x46\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x01\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\xc8\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x62\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x00\x00\x00\x00\x00\x00\x0c\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14\x04\x00\x00\x00\x00\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x31\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe7\x04\x00\x00\x00\x00\x00\x00\xb0\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x22\x00\x00\x00\x01\x00\x00\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x97\x08\x00\x00\x00\x00\x00\x00\xb9\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x87\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x0a\x00\x00\x00\x00\x00\x00\x5d\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x19\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xad\x0f\x00\x00\x00\x00\x00\x00\x3c\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4f\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe9\x11\x00\x00\x00\x00\x00\x00\x3a\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7f\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x13\x00\x00\x00\x00\x00\x00\xc0\x00\x00\x00\x00\x00\x00\x00\x0d\x00\x00\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe8\x13\x00\x00\x00\x00\x00\x00\x70\x05\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x04\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x15\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x58\x19\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x07\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x00\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x58\x1b\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x08\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x77\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x68\x1b\x00\x00\x00\x00\x00\x00\x8c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x00\x00\x03\x4c\xff\x6f\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf4\x1b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
end

function dump(data)
  len, gso_size, gso_segs, gso_type = string.unpack("=I4I2I2I4", data)
  return {
    gso_type=flags2str(gso_type),
    gso_segs=gso_segs,
    gso_size=gso_size,
    len=len
  }
end
