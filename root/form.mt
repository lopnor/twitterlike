? my ($form, $submit, $action) = @_;
? if ($action) {
<form method="POST" action="<?= $action ?>">
? } else {
<form method="POST">
? }
<table>
? for my $field (keys %{$form->fields}) {
    <tr>
        <th><?= raw_string $form->label($field) ?></th>
        <td>
            <?= raw_string $form->input($field) ?>
        </td>
        <td>
? if ($form->is_error($field)) {
<ul class="error_list">
? for my $err (@{$form->error_messages($field)}) {
    <li><?= raw_string $err ?></li>
? }
</ul>
? }
    </tr>
? }
        </td>
<tr>
    <td></td>
    <td colspan="2"><input type="submit" value="<?= $submit ?>"></td>
</tr>
</table>
</form>
