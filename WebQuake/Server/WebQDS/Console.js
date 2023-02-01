/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

Con = {};

Con.Print = function(msg)
{
	if (msg.charCodeAt(0) >= 3)
		process.stdout.write(msg);
	else
		process.stdout.write(msg.substring(1));
};

Con.DPrint = function(msg)
{
	if (Host.developer.value !== 0)
		Con.Print(msg);
};