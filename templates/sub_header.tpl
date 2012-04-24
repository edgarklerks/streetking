<div id="user-photo" class="ui-corner-all" style="background-image:url([:picture_small])"></div>
<div id="user-name-nick">[:firstname] [:lastname]<br><span>[:nickname] (level [:level])</span></div>
<div id="user-data-box">
	<div id="user-respect">
		<div>Respect</div>
		<div>
			<div class="user-data-box-text">[:respect]/???</div>
			<div class="progress-bar-box">
				<div class="progress-bar" style="left:-[:eval 100-((50/100)*100)]%"></div>
			</div>
		</div>
	</div>
	<div id="user-health">
		<div>Health <span>(00:00)</span></div>
		<div>
			<div class="user-data-box-text">[:energy]/[:max_energy]</div>
			<div class="progress-bar-box">
				<div class="progress-bar" style="left:-[:eval 100-((energy/max_energy)*100)]%"></div>
			</div>
		</div>
	</div>
	<div id="user-money">
		<div class="money">Money <b>SK$ <span>[:money]</span></b></div>
		<div class="diamonds">Diamonds <b><span>[:diamonds]</span></b></div>
	</div>
	<div class="clearfix"></div>
</div>
<!--
<div id="donce">
	<div>[:eval energy+5/2]</div>
	<span> energy: [:energy] </span> <span> $ [:money] </span>
</div>
-->