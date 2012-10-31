[:when (sortFieldsNames)]{
	<form id="list_form_filter" style="border:1px solid #f00; text-align:left;">
	[:repeat data:sortFieldsNames as:fName] {
		<div>[:fName] -> <input type="text" name="[:fName]" value=""></div>
	}
		<input type="submit" value="filter" id="filter">
	</form>
	[:sortFieldsNames]
}
<div id="list_elements">
</div>