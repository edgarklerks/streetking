<div class="declare-your-own-race-box" mtitle="Declare your own race">
	<form id="race-money-create" action="Race/challenge" method="post">
		<input type="hidden" name="track_id" id="track_id" value="" />
		<input type="hidden" name="type" id="type" value="money" />
		<div class="error">&nbsp;</div>
		<div id="declare-your-own-race-car-box" class="declare-your-own-race-car-box backgound-darkgray"></div>
		<div class="declare-your-own-race-tracks-box inner-scroll-box">
			<div id="declare-your-own-race-tracks-box"></div>
		</div>
		<div class="clearfix"></div>
		<div class="declare-your-own-race-money-box">
			<fieldset class="declare-your-own-race-money">
				<legend>declared race amount of money</legend>
				<input type="text" name="declare_money" id="declare_money" value="" class="ui-input-text ui-corner-all-2px" />
			</fieldset>
			<div class="buttons-panel">
				<input type="button" value="create" id="create" class="button" module="RACE_DECLARE" />
			</div>
		</div>
	</form>
</div>