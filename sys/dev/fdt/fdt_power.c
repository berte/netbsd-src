/* $NetBSD: fdt_power.c,v 1.1 2017/05/28 15:55:11 jmcneill Exp $ */

/*-
 * Copyright (c) 2017 Jared McNeill <jmcneill@invisible.ca>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <sys/cdefs.h>
__KERNEL_RCSID(0, "$NetBSD: fdt_power.c,v 1.1 2017/05/28 15:55:11 jmcneill Exp $");

#include <sys/param.h>
#include <sys/bus.h>
#include <sys/kmem.h>

#include <libfdt.h>
#include <dev/fdt/fdtvar.h>

struct fdtbus_power_controller {
	device_t power_dev;
	int power_phandle;
	const struct fdtbus_power_controller_func *power_funcs;

	struct fdtbus_power_controller *power_next;
};

static struct fdtbus_power_controller *fdtbus_power = NULL;

int
fdtbus_register_power_controller(device_t dev, int phandle,
    const struct fdtbus_power_controller_func *funcs)
{
	struct fdtbus_power_controller *power;

	power = kmem_alloc(sizeof(*power), KM_SLEEP);
	power->power_dev = dev;
	power->power_phandle = phandle;
	power->power_funcs = funcs;

	power->power_next = fdtbus_power;
	fdtbus_power = power;

	return 0;
}

void
fdtbus_power_reset(void)
{
	struct fdtbus_power_controller *power;

	for (power = fdtbus_power; power; power = power->power_next) {
		if (power->power_funcs->reset)
			power->power_funcs->reset(power->power_dev);
	}
}

void
fdtbus_power_poweroff(void)
{
	struct fdtbus_power_controller *power;

	for (power = fdtbus_power; power; power = power->power_next) {
		if (power->power_funcs->poweroff)
			power->power_funcs->poweroff(power->power_dev);
	}
}
