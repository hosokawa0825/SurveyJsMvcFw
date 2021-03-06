Iconv = require("iconv").Iconv

exports.toUtf8 = (body, $) ->
  conv = null
  encoding = $("meta[http-equiv='Content-Type']").attr("content") || $("meta[charset]").attr("charset") || $("?xml").attr("encoding")
  if encoding.match(/EUC-JP/i)
    conv = new Iconv('EUC-JP','UTF-8//TRANSLIT//IGNORE')
  else if encoding.match(/Shift_JIS/i)
    conv = new Iconv('Shift_JIS','UTF-8//TRANSLIT//IGNORE')
  else if encoding.match(/UTF-8/i)
    conv = new Iconv('UTF-8','UTF-8//TRANSLIT//IGNORE')

  if conv
    buffer = new Buffer(body, 'binary')
    buffer = conv.convert(buffer)
    return buffer.toString()
  else
    return body
