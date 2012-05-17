<div title="The sale">
	<div class="error">&nbsp;</div>
	<div class="sale-scrap-box">
		<div class="sale-scrap-box-text-container">Put to the scrap (<b>$SK [:0.total_price]</b>)</div>
		<div class="sale-scrap-box-button-container">
			<div class="sale-scrap-box-button-container-box"><a href="#Car/trash?id=[:0.id]" module="GARAGE_CAR_SCRAP" class="button">scrap</a></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<hr>
	<div class="sale-market-box">
		<div class="sale-market-box-text-container">Sell your car in the marketplace*:</div>
		<div class="sale-market-box-field-container"><input type="text" id="price" value="[:0.total_price]" maxlength="8"></div>
		<div class="sale-market-box-button-container"><a href="#Car/sell?car_instance_id=[:0.id]" module="GARAGE_CAR_SELL_MARKETPLACE" class="button">sell</a></div>
		<div class="clearfix"></div>
		<div class="sale-market-box-fee-text-container">Marketplace fee (<b>SK$ <span id="market_fee">10</span></b>)</div>
		<div class="clearfix"></div>
		<div class="note">*it cost 10% market fee</div>
	</div>
</div>