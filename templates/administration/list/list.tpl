[:when (sortFieldNames)]{
	<div class="horizontal-line">&nbsp;</div>
	<form id="list_form_filter" style="text-align:left;">
	[:repeat data:sortFieldNames as:fName] {
		[:when (res == "market_parts")]{
			[:when (fName == "name")]{
				<div><label>[:fName]:</label> <input type="text" name="[:fName]" value="" list="part_type" listFillField="name" class="ui-button-text"></div>
			}
			[:when (fName != "name")]{
				<div><label>[:fName]:</label> <input type="text" name="[:fName]" value="" class="ui-button-text"></div>
			}
			
		}
		[:when ((res != "market_parts"))]{
			<div><label>[:fName]:</label> <input type="text" name="[:fName]" value="" class="ui-input-text ui-corner-all-2px" class="ui-button-text"></div>
		}
	}
		<input type="submit" value="filter" id="filter">
	</form>
	<div style="clear:both"></div>
	<div class="horizontal-line">&nbsp;</div>
}
<div class="scroll-content" style="margin-top:3px">
	<table id="list_elements">
		[:when (sortFieldNames)]{
			<thead>
				<tr>
				[:repeat data:sortFieldNames as:fName] {
					<td>[:fName]</td>
				}
				<td>&nbsp;</td>
				</tr>
			</thead>
		}
		<tbody></tbody>
	</table>
</div>