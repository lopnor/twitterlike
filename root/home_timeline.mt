? extends 'base';

? block content => sub {
<form id="update_status" action="#">
<input type="text" size="50" name="status" />
<input type="submit" value="update" />
</form>
<div id="statuses">
<div id="append_here"></div>
</div>
<script type="text/javascript">
function insert_status (data) {
    var date = new Date(data.created_at);
    $('<div/>')
        .addClass('status')
        .html(data.user.screen_name + ':' + data.text + '(' + date.toDateString() + ')' )
        .insertAfter($('#append_here'));
}
$(function() {
    $(':input[name=status]').attr('autocomplete', 'off');
    $.getJSON(
        "<?= $c->uri_for('/statuses/home_timeline.json') ?>",
        function (statuses) {
            $.each(statuses.reverse(), function(i, e) {insert_status(e)});
        }
    );
});
$('#update_status').submit(function() {
    $.post(
        "<?= $c->uri_for('/statuses/update.json') ?>",
        $(this).serialize(),
        function (data) {
            insert_status(data);
            $('#update_status :input[name=status]').val('');
        },
        "json"
    );
    return false;
});
</script>
? };
