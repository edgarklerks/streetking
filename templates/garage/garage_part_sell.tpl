<div class="sale-box" mtitle="The sale">
	<div class="error">&nbsp;</div>
	<div class="sale-box-scrap">
		<div class="sale-box-text-container">Put to the scrap: <b>$SK [:0.trash_price]</b><a href="#?part_instance_id=[:requestParams.part_instance_id]" module="GARAGE_PART_SCRAP" class="button">scrap</a></div>
		<div class="clearfix"></div>
	</div>
	<div class="sale-box-market">
		<div class="sale-box-text-container">Sell your part in the marketplace*:</div>
		<div class="sale-box-text-container"><input type="text" id="price" value="[:0.trash_price]" maxlength="8" class="ui-input-text ui-corner-all-2px ui-input-width100"><a href="#[:requestParams.action]?part_instance_id=[:requestParams.part_instance_id]" module="GARAGE_PART_SELL_MARKETPLACE" class="button">sell</a></div>
		<div class="clearfix"></div>
		<div class="sale-box-text-container">Marketplace fee is <b>SK$ <span id="market_fee">10</span></b><span class="sale-box-text-note">*it cost 10% market fee</span></div>
		<div class="clearfix"></div>
	</div>
</div>