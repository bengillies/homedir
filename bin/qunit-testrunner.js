/*
 * Test code for QUnit, based on http://code.google.com/p/phantomjs/issues/detail?id=29
 */

var loadPage = function(url, action) {
	if(!phantom.state) {
		phantom.open(url);
		phantom.state = 'running-tests';
	} else {
		action();
	}
};


loadPage(phantom.args[0], function() {
	var $el = $('#qunit-testresult'),
		exitStatus = 0;

	window.setInterval(function() {
		if (/^Tests completed/.test($el.text())) {
			try {
				exitStatus = extractResults($el);
			} catch (e) {
				console.log('Error finding results: ' + e);
			}

			phantom.exit(exitStatus);
		} else {
			console.log('Running tests');
		}
	}, 100);
});

var extractResults = function($el) {
	var passed = $el.find('.passed').text(),
		total = $el.find('.total').text(),
		failed = parseInt($el.find('.failed').text(), 10);

	console.log('');
	if (failed > 0) {
		$('#qunit-tests').children('.fail').each(function(i, module) {
			var $module = $(module),
				moduleName = $module.find('.module-name').text(),
				testName = $module.find('.test-name').text(),
				countFailed = $module.find('.counts .failed').text();

			console.log('Module: ' + moduleName + ', Test: ' + testName +
				', Failed: ' + countFailed);
			$module.find('li').each(function(i, el) {
				var $el = $(el);
				if ($el.hasClass('fail')) {
					var failTitle = $el.find('.test-message').text() ||
							$el.text() || 'Test Failed',
						expected = $el.find('.test-expected').text(),
						actual = $el.find('.test-actual').text();
					console.log('    ' + (i + 1) + ' -> ' + failTitle);
					if (expected) {
						console.log('        - ' + expected);
					}
					if (actual) {
						console.log('        - ' + actual);
					}
				}
			});
		});
	}

	console.log('-----------------------------------------------------------');
	console.log('Passed: '+ passed + ', Failed: '+ failed + ' Total: '+ total);
	console.log('');
	return (failed) ? 1 : 0;
};
