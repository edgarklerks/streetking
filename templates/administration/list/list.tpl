[:when (sortFieldNames)]{
	<div class="form-div">
		<form id="list_form_filter">
			[:repeat data:sortFieldNames as:fName] {
				[:when (res == "market_parts")]{
					[:when (fName == "name")]{
						<div><label>[:fName]:</label><input type="text" name="[:fName]" value="" list="part_type" listFillField="name"></div>
					}
					[:when (fName != "name")]{
						<div><label>[:fName]:</label><input type="text" name="[:fName]" value=""></div>
					}
					
				}
				[:when ((res != "market_parts"))]{
					<div><label>[:fName]:</label> <input type="text" name="[:fName]" value=""></div>
				}
			}
			<div class="clearfix"></div>
			<div class="buttons-container">
				<input type="submit" value="Sort" id="filter">
				<input type="reset" value="Clear" class="button" />
			</div>
		</form>
	</div>
}
<div class="scroll-content">
	<div class="fixed-table-container">
		<div class="header-background"> </div>
		<div class="fixed-table-container-inner">
			<table id="list_elements">
				[:when (sortFieldNames)]{
					<thead>
						<tr>
							[:repeat data:sortFieldNames as:fName] {
								<th width="[:ttt]"><div class="th-inner" style="width:[:ttt]px">[:fName]</div></th>
							}
						</tr>
					</thead>
				}
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>