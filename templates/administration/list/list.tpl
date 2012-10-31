[:when (sortFieldNames)]{
	<form id="list_form_filter" style="border:1px solid #f00; text-align:left;">
	[:repeat data:sortFieldNames as:fName] {
		[:when ((res == "market_parts") & (fName == "name"))]{
			<div>[:fName] -> <input type="text" name="[:fName]" value="" list="part_type" listFillField="name"></div>
			[:continue]
		}
		[:when ((res == "market_parts") & (fName != "name"))]{
			<div>[:fName] -> <input type="text" name="[:fName]" value=""></div>
		}
		[:when ((res != "market_parts"))]{
			<div>[:fName] -> <input type="text" name="[:fName]" value=""></div>
		}
	}
		<input type="button" value="filter" id="filter">
	</form>
	[:sortFieldNames]
}
<div id="list_elements">
</div>