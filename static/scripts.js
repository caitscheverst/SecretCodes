(function() {
  var arbits, connect, drawBeziers, worlds;

  connect = function($top, $bottom, $canvas, colour) {
    var bottom_x, bottom_y, context, sharpness, top_x, top_y;
    top_x = $top.offset().left + ($top.width() / 2) - $canvas.offset().left + 4;
    top_y = $top.offset().top + $top.height() - $canvas.offset().top + 6;
    bottom_x = $bottom.offset().left + ($bottom.width() / 2) - $canvas.offset().left + 4;
    bottom_y = $bottom.offset().top - $canvas.offset().top;
    context = $canvas.get(0).getContext("2d");
    context.lineWidth = 2;
    context.strokeStyle = colour;
    context.beginPath();
    sharpness = (bottom_y - top_y) / 1.618;
    context.moveTo(top_x, top_y);
    context.bezierCurveTo(top_x, top_y + sharpness, bottom_x, bottom_y - sharpness, bottom_x, bottom_y);
    return context.stroke();
  };

  worlds = {
    first: "#718c00",
    second: "#4271ae",
    third: "#c82829",
    data: "#000",
    checksum: "#999"
  };

  drawBeziers = function() {
    var $canvas, $hither, $thither, colour, id, _results;
    $canvas = $('#canvas');
    _results = [];
    for (id in worlds) {
      colour = worlds[id];
      $hither = $("#explanation ." + id);
      $thither = $("#bits ." + id);
      if ($hither.length && $thither.length) {
        _results.push(connect($hither, $thither, $canvas, colour));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  arbits = ["978-18-53260865", "123456789999", "192.168.0.0/24", "01:23:45:67:89:ab", "f47ac10b-58cc-4372-a567-0e02b2c3d479", "A02-2009-000004BE-A"];

  $('#random').click(function(e) {
    return $('#code').val(arbits[Math.floor(Math.random() * arbits.length)]);
  });

  $('#submit').click(function(e) {
    $.ajax({
      url: "/query/" + $('#code').val(),
      cache: false,
      success: function(data, textStatus, jqXHR) {
        $('#results').html(data);
        return drawBeziers();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        return $('#results').html("Error: " + textStatus + " + " + errorThrown);
      }
    });
    return $('#results').html("Tis loadin'");
  });

}).call(this);
