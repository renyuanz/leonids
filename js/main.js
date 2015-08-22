$(document).ready(function() {
  var colors = ["#48466D", "#D4CEB0", "#FEAA2B", "#FF5757", "#6B3278", "#362999", "#4262C5", "#F6538F", "#BA6C65"],
      tags = $("a.post-tag");

  for (var i = 0; i < tags.length; i++) {
    var selectedColor = colors[Math.floor(Math.random()*colors.length)];
    $(tags[i]).css('background-color', selectedColor);
  }
});
