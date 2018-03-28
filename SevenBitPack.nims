
const
  encodeMask: array[7, byte] = [1'u8, 3, 7, 15, 31, 63, 127]
  decodeMask: array[7, byte] = [128'u8, 192, 224, 240, 248, 252, 254]

proc packBytes*(unpackedBytes: seq[byte], replaceInvalidChars: bool): seq[byte] =
  const defaultByte: byte = byte('?')
  var
    shiftedBytes: seq[byte] = newSeq[byte](unpackedBytes.len - unpackedBytes.len div 8)
    shiftOffset: int = 0
    shiftIndex: int = 0
    
  # Shift the unpacked bytes to the right according to the offset (position of the byte)
  for b in unpackedBytes:
    var tmpByte = b
    # Handle invalid characters (bytes out of range)
    if tmpByte > byte(127):
      if not replaceInvalidChars:
        echo "error"
        quit()
      else:
        tmpByte = defaultByte 
    # Perform the byte shifting
    if shiftOffset == 7:
      shiftOffset = 0
    else:
      shiftedBytes[shiftIndex] = byte(tmpByte shr shiftOffset)
      inc shiftOffset
      inc shiftIndex
    
  var
    moveOffset, moveIndex: int = 1
    packIndex: int = 0
    packedBytes: seq[byte] = newSeq[byte](shiftedBytes.len)
  # Move the bits to the appropriate byte (pack the bits)
  for b in unpackedBytes:
    if moveOffset == 8:
      moveOffset = 1
    else:
      if moveIndex != unpackedBytes.len:
        # Extract the bits to be moved
        var extractedBitsByte: byte = unpackedBytes[moveIndex] and encodeMask[moveOffset - 1]
        # Shift the extracted bits to the proper offset
        extractedBitsByte = extractedBitsByte shl (8 - moveOffset)
        # Move the bits to the appropriate byte (pack the bits)
        var movedBitsByte = extractedBitsByte or shiftedBytes[packIndex]
        packedBytes[packIndex] = movedBitsByte
        inc moveOffset
        inc packIndex
      else:
        packedBytes[packIndex] = shiftedBytes[packIndex]
    inc moveIndex
  result = packedBytes

proc unpackBytes*(packedBytes: seq[byte]): seq[byte] =
  var
    shiftedBytes: seq[byte] = newSeq[byte]((packedBytes.len * 8) div 7)
    shiftOffset, shiftIndex: int = 0
  
  # Shift the packed bytes to the left according to the offset (position of the byte)
  for b in packedBytes:
    if shiftOffset == 7:
      shiftedBytes[shiftIndex] = 0
      shiftOffset = 0
      inc shiftIndex
    shiftedBytes[shiftIndex] = byte((b shl shiftOffset) and 127)
    inc shiftOffset
    inc shiftIndex
  var
    moveOffset, moveIndex: int = 0
    unpackIndex = 1
    unpackedBytes: seq[byte] = newSeq[byte](shiftedBytes.len)
  if shiftedBytes.len > 0:
    unpackedBytes[unpackIndex - 1] = shiftedBytes[unpackIndex - 1]
  
  # Move the bits to the appropriate byte (unpack the bits)
  for b in packedBytes:
    if unpackIndex != shiftedBytes.len:
      if moveOffset == 7:
        moveOffset = 0
        inc unpackIndex
        unpackedBytes[unpackIndex - 1] = shiftedBytes[unpackIndex - 1]
      if unpackIndex != shiftedBytes.len:
        # Extract the bits to be moved
        var extractedBitsByte = packedBytes[moveIndex] and decodeMask[moveOffset]
        # Shift the extracted bits to the proper offset
        extractedBitsByte = extractedBitsByte shr (7 - moveOffset)
        # Move the bits to the appropriate byte (unpack the bits)
        var movedBitsByte = extractedBitsByte or shiftedBytes[unpackIndex]
        unpackedBytes[unpackIndex] = byte(movedBitsByte)
        inc moveOffset
        inc unpackIndex
        inc moveIndex
  
  # Remove the padding if exists
  if unpackedBytes[unpackedBytes.len - 1] == 0:
    unpackedBytes.setLen(unpackedBytes.len - 1)
  result = unpackedBytes

proc stringToSeq(s: string): seq[byte] =
  result = @[]
  for c in s:
    result.add(byte(c))

proc seqToString(sequence: seq[byte]): string =
  result = ""
  for c in sequence:
    result = result & char(c)

proc main() =
  var 
    statement: string
    statementAsSequence: seq[byte]
    packedStatementAsSequence: seq[byte]
    unpackedStatementAsSequence: seq[byte]
    unpackedStatement: string
  # Original Statement
  statement = paramStr(3)
  # Statement converted to sequence of bytes
  statementAsSequence = stringToSeq(statement)
  # Statement where 8th bit in ASCII is discarded and used
  # to store 1st bit of next character
  packedStatementAsSequence = packBytes(statementAsSequence, true)
  # Unpacked statement as sequence of bytes
  unpackedStatementAsSequence = unpackBytes(packedStatementAsSequence)
  # Unpacked statement as string
  unpackedStatement = seqToString(unpackedStatementAsSequence)

  echo "Statement:                     ", statement
  echo "Statement As Sequence:         ", statementAsSequence.repr
  echo "Packed Statement As Sequence:  ", packedStatementAsSequence.repr
  echo "Unpacked Statement As Sequence:", unpackedStatementAsSequence.repr
  echo "Unpacked Statement:            ", unpackedStatement
main() 
