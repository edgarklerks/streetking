<div title="The sale">
	<div class="error">&nbsp;</div>
	<div class="sale-scrap-box">
		<div class="sale-scrap-box-text-container">Put to the scrap (<b>$SK [:0.trash_price]</b>)</div>
		<div class="sale-scrap-box-button-container">
			<div class="sale-scrap-box-button-container-box"><a href="#?part_instance_id=[:requestParams.part_instance_id]" module="GARAGE_PART_SCRAP" class="button">scrap</a></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<hr>
	<div class="sale-market-box">
		<div class="sale-market-box-text-container">Sell your part in the marketplace*:</div>
		<div class="sale-market-box-field-container"><input type="text" id="price" value="[:0.trash_price]" maxlength="8"></div>
		<div class="sale-market-box-button-container"><a href="#[:requestParams.action]?part_instance_id=[:requestParams.part_instance_id]" module="GARAGE_PART_SELL_MARKETPLACE" class="button">sell</a></div>
		<div class="clearfix"></div>
		<div class="sale-market-box-fee-text-container">Marketplace fee (<b>SK$ <span id="market_fee">10</span></b>)</div>
		<div class="clearfix"></div>
		<div class="note">*it cost 10% market fee</div>
	</div>
</div>