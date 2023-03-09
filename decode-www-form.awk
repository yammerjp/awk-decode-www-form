function decode_www_form(encoded_str,    encoded_parts, key, value, equal_index) {
  delete KV
  split(encoded_str, encoded_parts, "&");

  for (i in encoded_parts) {
    if (encoded_parts[i] == "") {
      continue
    }
    key = encoded_parts[i]
    value = ""

    # split =
    equal_index = index(key, "=")
    if (equal_index > 0) {
      value = substr(key, equal_index + 1)
      key = substr(key, 1, equal_index - 1)
    }

    # replace +
    gsub("+", " ", key)
    gsub("+", " ", value)

    # utf-8 percent decode
    key = decode_utf8_parcent_encoding(key)
    value = decode_utf8_parcent_encoding(value)
    KV[key] = value
  }
}

function decode_utf8_parcent_encoding(encoded_str,    chars, decoded_str, L, N, num, utf16num) {
  L = length(encoded_str)
  N = 1
  decoded_str = ""
  split(encoded_str, chars, "")
  while (N<=L) {
    if (chars[N] != "%" || N+2 > L) {
      decoded_str = decoded_str chars[N]
      N++
      continue
    }

    # TODO: byte sequence verificaction
    if (chars[N+1] ~ /^[0-7]$/ ) {
      num = strtonum("0x" chars[N+1] chars[N+2])
      utf16num = num
      N+=3
    } else if (chars[N+1] ~ /^[c-dC-D]$/ && chars[N+3] = "%") {
      num = strtonum("0x" chars[N+1] chars[N+2] chars[N+4] chars[N+5])
      utf16num = (((num - (num % 256)) / 256) % 32) * 64 + (num % 64)
      N+=6
    } else if (chars[N+1] ~ /^[eE]$/ && chars[N+3] == "%" && chars[N+6] == "%") {
      num = strtonum("0x" chars[N+1] chars[N+2] chars[N+4] chars[N+5] chars[N+7] chars[N+8])
      utf16num = (((num - (num % 65536)) / 65536) % 16) * 4096 + (((num - (num % 256)) / 256) % 64) * 64 + (num % 64);
      N+=9
    } else if (chars[N+1] ~ /^[fF]$/ && chars[N+3] == "%" && chars[N+6] == "%" && chars[N+9] == "%") {
      num = strtonum("0x" chars[N+1] chars[N+2] chars[N+4] chars[N+5] chars[N+7] chars[N+8] chars[N+10] chars[N+11])
      utf16num = (((num - (num % 16777216))/ 16777216) % 8) * 262144 + (((num - (num % 65536)) / 65536) % 64) * 4096 + (((num - (num % 256)) / 256) % 64) * 64 + (num % 64)
      N+=12
    } else {
      print "failed"
      exit
    }
    decoded_str = sprintf("%s%c", decoded_str, utf16num)
  }
  return decoded_str
}
