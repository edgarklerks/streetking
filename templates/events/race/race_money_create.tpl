<div class="declare-your-own-race-box" mtitle="Declare your own race">
	<form id="race-money-create" action="Race/challenge" method="post">
		<input type="hidden" name="track_id" id="track_id" value="" />
		<input type="hidden" name="type" id="type" value="money" />
		<div class="error">&nbsp;</div>
		<div id="declare-your-own-race-car-box" class="declare-your-own-race-car-box backgound-darkgray"></div>
		<div id="declare-your-own-race-car-track-container" class="declare-your-own-race-car-track-container backgound-darkgray">
			<div id="declare-your-own-race-car-tracks-content" class="declare-your-own-race-car-tracks-content">
				<ul id="declare-your-own-race-car-tracks-content-elements"></ul>
			</div>
			<div class="controls">
				<a href="#" class="prev-slide slide-button">&nbsp;</a><a href="#" class="next-slide slide-button">&nbsp;</a>
			</div>
		</div>
		<div class="clearfix"></div>
		<div class="declare-your-own-race-money-box">
			<div class="declare-your-own-race-amount-text">Declared race amount of money: SK$</div>
			<div class="declare-your-own-race-amount-field"><input type="text" name="declare_money" id="declare_money" value="" size="10" class="ui-input-text ui-corner-all-2px" /></div>
			<div class="declare-your-own-race-amount-button"><input type="button" value="create a new race" id="create" class="button" module="RACE_DECLARE" /></div>
		</div>
		<div class="clearfix"></div>
	</form>
</div>