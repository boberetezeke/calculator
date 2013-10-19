//
// hello <%= @name %>
//
var $hello = (function(__opal) {
  var TMP_1, $a, $b, $c, 
    self = __opal.top, 
    __scope = __opal, 
    $mm = __opal.mm, 
    nil = __opal.nil, 
    __breaker = __opal.breaker, 
    __slice = __opal.slice;
  return 
    (
      $a = (
        ($b = (
          ($c = __scope.ERB) == null ? __opal.cm("ERB") : $c)
        ).$new || $mm('new')
      ), 
      $a._p = (
        TMP_1 = function() {
          var self = TMP_1._s || this, $a, $b, $c, $d, out = nil;
          if (self.name == null) self.name = nil;
          out = [];
          (($a = out)['$<<'] || $mm('<<')).call($a, "hello ");
          (($b = out)['$<<'] || $mm('<<')).call($b, self.name);
          (($c = out)['$<<'] || $mm('<<')).call($c, "\n");
          return (($d = out).$join || $mm('join')).call($d);
        }, 
        TMP_1._s = self, 
        TMP_1
      ), $a
    ).call($b, "test")
  })(Opal); 
