
include $(TOPDIR)/rules.mk

PKG_SOURCE_URL:=https://github.com/Richard-Tung/n2n
PKG_SOURCE_VERSION:=d8d1257704a4713821a8fba2b1362b080d6779b9

PKG_NAME:=n2n
PKG_VERSION:=2.1_git$(PKG_SOURCE_VERSION)
PKG_RELEASE:=1
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/n2n/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=N2N VPN tunneling daemon(V2)
  URL:=http://www.ntop.org/n2n/
  SUBMENU:=VPN
  DEPENDS:=+kmod-tun +resolveip +libopenssl
endef

define Package/n2n-edge
$(call Package/n2n/Default)
endef

define Package/n2n-supernode
$(call Package/n2n/Default)
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(PKG_BUILD_DIR)/n2n_v2/* $(PKG_BUILD_DIR)
endef

#define Build/Compile
#		$(MAKE) -C $(PKG_BUILD_DIR) \
#		$(TARGET_CONFIGURE_OPTS) \
#		CFLAGS="$(TARGET_CFLAGS)" \
#		INSTALL_PROG=":"
#endef

define Package/n2n-edge/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/edge $(1)/usr/sbin/edge
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/edge.init $(1)/etc/init.d/n2n-edge
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/edge.config $(1)/etc/config/n2n-edge
endef

define Package/n2n-edge/conffiles
	/etc/config/n2n-edge
endef

define Package/n2n-supernode/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/supernode $(1)/usr/sbin/supernode
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/supernode.init $(1)/etc/init.d/n2n-supernode
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/supernode.config $(1)/etc/config/n2n-supernode
endef

define Package/n2n-supernode/conffiles
	/etc/config/n2n-supernode
endef

$(eval $(call BuildPackage,n2n-edge))
$(eval $(call BuildPackage,n2n-supernode))
