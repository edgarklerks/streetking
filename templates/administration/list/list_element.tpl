[:when (fields)]{
	<tr class="fill_btn" fill_id="[:id]">
	[:repeat data:fields as:field] {
		
		<td>[:field]</td> 
	}
	</tr>
}
