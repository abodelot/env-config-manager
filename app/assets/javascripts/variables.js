$(function() {

$('a.save-variable').click(function() {
  console.log("click");
  var target = $(this).attr('href');
  var row = $(this).closest('tr');
  var key = row.find('input[name=key]').val();
  var value = row.find('input[name=value]').val();
  $.ajax({
    method: 'PUT',
    url: target,
    data: {
      variable : {
        key: key,
        value: value
      }
    }
  })
  .done(function() {
    new PNotify("Var <code>" + key + "</code> saved!")
  })
  .fail(function() {
    new PNotify("Cannot save variable <code>" + key + "</code>");
  });

  return false;
});


});
