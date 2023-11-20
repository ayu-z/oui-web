<template>
  <div>
    <div>
      <n-h2>{{ $t('InterFace Mode') }}</n-h2>
      <n-form size="large" ref="form" label-placement="left" label-width="80px" :model="formValue" :rules="rules">
        <n-form-item :label="$t('Mode')" path="mode">
          <n-select v-model="formValue.mode" :options="ifaceTransmode" filterable @update:value="handlemodeChange" :defaultValue="defaultMode" />
        </n-form-item>
      </n-form>
    </div>

    <div v-if="showWANSetting">
      <n-h2>{{ $t('WAN Setting') }}</n-h2>
      <n-form size="large" ref="form" label-placement="left" label-width="80px" :model="formValue" :rules="rules">
        <n-form-item :label="$t('Mode')" path="wan">
          <n-select v-model="formValue.wan.proto" :options="wanmodeTransmode" filterable  @update:value="handlewanmodeChange" />
        </n-form-item>
        <div v-if="showStaticSetting">
          <n-form-item :label="$t('IPAddr')" path="wan">
            <n-input v-model:value="formValue.wan.static.ipaddr"/>
          </n-form-item>
          <n-form-item :label="$t('NetMask')" path="wan">
            <n-input v-model:value="formValue.wan.static.netmask"/>
          </n-form-item>
          <n-form-item :label="$t('GateWay')" path="wan">
            <n-input v-model:value="formValue.wan.static.gateway"/>
          </n-form-item>
        </div>
        <div v-if="showPPPOESetting">
          <n-form-item :label="$t('UserName')" path="wan">
            <n-input v-model:value="formValue.wan.pppoe.username"/>
          </n-form-item>
          <n-form-item :label="$t('Password')" path="wan">
            <n-input v-model:value="formValue.wan.pppoe.passwd"/>
          </n-form-item>
        </div>
      </n-form>
    </div>

    <div>
      <n-h2>{{ $t('LAN Setting') }}</n-h2>
      <n-form size="large" ref="form" label-placement="left" label-width="80px" :model="formValue" :rules="rules">
      <n-form-item :label="$t('IPAddr')" path="lan">
        <n-input v-model:value="formValue.lan.ipaddr"/>
      </n-form-item>
      <n-form-item :label="$t('NetMask')" path="lan">
        <n-input v-model:value="formValue.lan.netmask"/>
      </n-form-item>
    </n-form>
    </div>

    <div>
      <n-space justify="end" style="padding-right: 100px">
        <n-button type="primary" :loading="loading" @click="handleSubmit">{{ $t('Save & Apply') }}</n-button>
      </n-space>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      formValue: {
        mode: '',
        wan: {
          proto: '',
          pppoe :{
            username:'',
            passwd:''
          },
          static :{
            ipaddr:'',
            netmask:'',
            gateway:''
          }
        },
        lan: {
          ipaddr: '',
          netmask: ''
        }
      },
      defaultMode:'1-WAN N-LAN',
      mode: ['1-WAN N-LAN', 'Full-LAN'],
      wanmode: ['DHCP', 'Static', 'PPPOE'],
      showWANSetting: false,
      showStaticSetting: false,
      showDHCPSetting: false,
      showPPPOESetting: false,
      rules: {
        // 'lan.ipaddr': [
        //   { required: true, message: this.$t('IP Address is required'), trigger: 'blur' },
        //   { validator: this.validateIPAddress, trigger: 'blur' }
        // ],
        'lan.ipaddr': {
          required: true,
          trigger: 'blur',
          validator: (_, value) => {
            if (!value)
              return Error(this.$t('This field is required'))

            if (value.length <= 15 && (value.match(/^[a-zA-Z0-9_]+$/) || (value.match(/^[a-zA-Z0-9_][a-zA-Z0-9_\-.]*[a-zA-Z0-9]$/) && value.match(/[^0-9.]/))))
              return
            return Error(this.$t('Invalid IPAddr'))
          }
        }
      }
    }
  },
  computed: {
    ifaceTransmode() {
      return this.mode.map((option) => ({
        value: option,
        label: this.$t(option)
      }))
    },
    wanmodeTransmode() {
      return this.wanmode.map((option) => ({
        value: option,
        label: this.$t(option)
      }))
    }

  },
  created() {
    this.defaultMode = '1-WAN N-LAN'
    let default_mode = '1-WAN N-LAN'
    this.$oui.ubus('uci', 'get', { 'config': 'network', 'section': '@switch_vlan[1]' })
      .then(r => {
        if (r.values.ports === '4 5') {
          default_mode = '1-WAN N-LAN'
        } else {
          default_mode = 'Full-LAN'
        }
      }),
    this.defaultMode = default_mode,
    this.handlemodeChange(default_mode),
    this.$oui.ubus('uci', 'get', { 'config': 'network', 'section': 'lan' })
      .then(r => {
        this.formValue.lan.ipaddr = r.values.ipaddr,
        this.formValue.lan.netmask = r.values.netmask
      }),
    this.$oui.ubus('uci', 'get', { 'config': 'network', 'section': 'wan' })
      .then(r => {
        this.formValue.wan.proto = r.values.proto,
        this.formValue.wan.static.ipaddr = r.values.ipaddr,
        this.formValue.wan.static.netmask = r.values.netmask,
        this.formValue.wan.static.gateway = r.values.gateway,
        this.formValue.wan.pppoe.username = r.values.username,
        this.formValue.wan.pppoe.passwd = r.values.password
      })
  },
  methods: {
    handlemodeChange(select) {
      this.showWANSetting = (select === '1-WAN N-LAN')
      this.defaultMode = select
    },
    handlewanmodeChange(select) {
      this.showStaticSetting = (select === 'Static')
      this.showPPPOESetting = (select === 'PPPOE')
      this.formValue.wan.proto = select
    },
    handleSubmit() {
      this.$refs.form.validate(async errors => {
        if (errors)
          return

        this.loading = true

        console.log('Selected option:', this.formValue.wan.proto, this.formValue.wan.pppoe.username, this.formValue.wan.pppoe.passwd)
        let proto = this.formValue.wan.proto
        let ipaddr = this.formValue.wan.static.ipaddr
        let netmask = this.formValue.wan.static.netmask
        let gateway = this.formValue.wan.static.gateway
        let username = this.formValue.wan.pppoe.username
        let password = this.formValue.wan.pppoe.passwd
        await this.$oui.call('uci', 'set', {
          config: 'network',
          section: 'wan',
          values: { proto, ipaddr, netmask, gateway, username, password}
        })

        ipaddr = this.formValue.lan.ipaddr
        netmask = this.formValue.lan.netmask
        await this.$oui.call('uci', 'set', {
          config: 'network',
          section: 'lan',
          values: { ipaddr, netmask}
        })
        await this.$oui.reloadConfig('network')

        this.loading = false

        this.$message.success(this.$t('Configuration has been applied'))
      })
    }
  }
}
</script>

<i18n src="./locale.json"/>
