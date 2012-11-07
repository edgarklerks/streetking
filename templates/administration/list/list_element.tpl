[:when (fields)]{
	<tr>
	[:repeat data:fields as:field] {
		
		<td>[:field]</td> 
	}
	<td><input type="button" class="fill_btn" value="fill this" id="[:id]" /></td>
	</tr>
}
