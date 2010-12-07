$(function() {
  
  // message.notice needs to be removed on a timer.

  window.renderTemplate = function(temp_path, vars) {
    var result = '';
    tmpl_result = '';

    $.ajax({
      url: temp_path,
      async: false,
      success: function(data) {
        options = {locals: vars};
        result = Haml.render(data, options);
      }
    });
    return result;
e };

  $('.command').live('keyup', function() {
    command     = $(this).val().split(/\r\n|\r|\n/);
    parent_div  = $(this).parent().parent();
    pre_area    = parent_div.find('.pre:first');
    pre_area.html(command.join(' && '));
  });


  $('.show_step').click(function() {
    parent = $(this).parent().parent().parent();
    parent.find('.step-form:first').toggle();
  });

  $('.addstep').click(function() {
    step = $('.step:first').clone();
    cmd_cnt = $('.step').length;
    step.find('h2').html('New Command');
    step.find('.pre').html('');
    
    step.find(':input').each(function() {
      field = $(this);
      if(field.hasClass('command')) {
        // our textarea
        field.prev().attr('for', 'project_steps_attributes_' + cmd_cnt + '_command');
        field.attr('name', 'project[steps_attributes][' + cmd_cnt + '][command]');
        field.attr('id', 'project_steps_attributes_' + cmd_cnt + '_command');
      } else {
        // input fields
        field.prev().attr('for', 'project_steps_attributes_' + cmd_cnt + '_name');
        field.attr('name', 'project[steps_attributes][' + cmd_cnt + '][name]');
        field.attr('id', 'project_steps_attributes_' + cmd_cnt + '_name');
      }
      field.val('');
    })
    $('.step:last').after(step);
  });
  

  $('a.delete_step').live('click', function(e) {
    e.preventDefault();
    do_delete = confirm("Are you sure you want to delete this step?");
    if(do_delete) {
      url = $(this).attr('href');
      $(this).parent().slideUp('slow', function() {
        $(this).remove();
      });
      $.get(url);
    }
  });


});
