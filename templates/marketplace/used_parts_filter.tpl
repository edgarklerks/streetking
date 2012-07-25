<div class="filter-box" title="Filtration">
	<form id="marketplace-filter-form">
		<input type="hidden" name="me" id="me" value="[:requestParams.me]"/>
		<fieldset class="filter-type-box">
			<legend>By level</legend>
			<div class="filter-input-box"><label>from:</label><input type="text" name="level-min" id="level-min" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="filter-input-box"><label>to:</label><input type="text" name="level-max" id="level-max" value="" class="ui-input-text ui-corner-all-2px" /></div>
		</fieldset>
		<div class="clearfix"></div>
		<fieldset class="filter-type-box">
			<legend>By price $SK</legend>
			<div class="filter-input-box"><label>from:</label><input type="text" name="price-min" id="price-min" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="filter-input-box"><label>to:</label><input type="text" name="price-max" id="price-max" value="" class="ui-input-text ui-corner-all-2px" /></div>
		</fieldset>
		<div class="clearfix"></div>
		<div class="buttons-panel">
			<input type="button" value="filter" id="filter" class="button" module="MARKETPLACE_FILTER">
		</div>
		<div class="clearfix"></div>
	</form>
</div>