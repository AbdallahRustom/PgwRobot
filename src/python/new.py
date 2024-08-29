import struct

def bcd(chars):
    
    bcd_string = ""
    for i in range(len(chars) // 2):
        bcd_string += chars[1+2*i] + chars[2*i]   
    bcd_bytes = bytearray.fromhex(bcd_string)

    return bcd_bytes  

def add_serving_network_v2(instance, mccmnc):
    if len(mccmnc) == 5:
        mnc3 = 'f'
    else:
        mnc3 = mccmnc[5]
    return b'\x53' + struct.pack("!H", 3) + struct.pack("!B", instance) + bcd(mccmnc[0] + mccmnc[1] + mccmnc[2] + mnc3 + mccmnc[3] + mccmnc[4])
