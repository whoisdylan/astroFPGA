#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
 .name = KBUILD_MODNAME,
 .init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
 .exit = cleanup_module,
#endif
 .arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x14522340, "module_layout" },
	{ 0x6bc3fbc0, "__unregister_chrdev" },
	{ 0x1fedf0f4, "__request_region" },
	{ 0x69a358a6, "iomem_resource" },
	{ 0xd691cba2, "malloc_sizes" },
	{ 0xfa0d49c7, "__register_chrdev" },
	{ 0x5252f304, "__memcpy_toio" },
	{ 0xea147363, "printk" },
	{ 0xbfbcb10f, "pci_find_device" },
	{ 0x85f8a266, "copy_to_user" },
	{ 0xb4390f9a, "mcount" },
	{ 0x748caf40, "down" },
	{ 0xa8a6f639, "__check_region" },
	{ 0x42c8de35, "ioremap_nocache" },
	{ 0xc5aa6d66, "pci_bus_read_config_dword" },
	{ 0x7c61340c, "__release_region" },
	{ 0xf666cbb3, "__memcpy_fromio" },
	{ 0x2044fa9e, "kmem_cache_alloc_trace" },
	{ 0xe52947e7, "__phys_addr" },
	{ 0x37a0cba, "kfree" },
	{ 0xedc03953, "iounmap" },
	{ 0x3f1899f1, "up" },
	{ 0xa12add91, "pci_enable_device" },
	{ 0x3302b500, "copy_from_user" },
	{ 0x6e9681d2, "dma_ops" },
	{ 0xf20dabd8, "free_irq" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "E84A199E6FD4D3D683D2479");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 4,
};
