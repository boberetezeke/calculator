function json2hash(json_str) {
  var hash = Opal.Hash.$new();
  var json = JSON.parse(json_str);
  var key, value;
  for (key in json) {
    value = json[key];
    if (value == null)
      value = Opal.nil;
    hash["$[]="](key, value);
  }
  return hash;
}
