<form id="filter" action="[:action]" method="post">
	<div class="error">&nbsp;</div>
	<div class="form-fields">
		[:when (fields)]{
			[:repeat data:fields as:f] {
				<div><label>[:f.name]:</label> <input type="text" name="[:f.name]" value="[:f.val]"></div>
			}
		}
	</div>
	<div class="form-buttons">
		
		<input type="submit" value="Sort" id="sort" module="[:module]">
	</div>
</form>
<div class="clearfix"></div>
<div class="horizontal-line">&nbsp;</div>
<div id="list">[:list]</div>