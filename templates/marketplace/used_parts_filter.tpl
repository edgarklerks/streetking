<div class="filter-box" title="Filtering">
	<form id="marketplace-filter-form">
		<input type="hidden" name="me" id="me" value="[:requestParams.me]"/>
		<div class="filter-title-box filter-title-box-by-level">
			<div class="filter-title-box-name">By level</div>
			<div class="filter-title-box-line">&nbsp;</div>
			<div class="clearfix"></div>
		</div>
		<div class="filter-box-fields-box">
			<div class="filter-input-box"><label>from:</label><input type="text" name="level-min" id="level-min" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="filter-input-box"><label>to:</label><input type="text" name="level-max" id="level-max" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="clearfix"></div>
		</div>
		<div class="filter-title-box filter-title-box-by-price">
			<div class="filter-title-box-name">By price $SK</div>
			<div class="filter-title-box-line">&nbsp;</div>
			<div class="clearfix"></div>
		</div>
		<div class="filter-box-fields-box">
			<div class="filter-input-box"><label>from:</label><input type="text" name="price-min" id="price-min" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="filter-input-box"><label>to:</label><input type="text" name="price-max" id="price-max" value="" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="clearfix"></div>
		</div>
		<div class="buttons-panel">
			<input type="button" value="filter" id="filter" class="button" module="MARKETPLACE_FILTER">
		</div>
		<div class="clearfix"></div>
	</form>
</div>