<template>
 <br>
 <n-radio-group v-model:value="myflag">
        <n-space style="padding-left: 150px">
          <n-button type="primary" :loading=loading @click="dialrun">{{ $t('run') }}</n-button>
          <n-radio :label="$t('automatic')" value="0" />
          <n-radio :label="$t('manual')" value="1" />
        </n-space>
 </n-radio-group>
      <br>
      <br>
 <n-form ref="form" :model="tableValue"  label-placement="left" label-width="150px"  v-if="1">
			<n-form-item :label="$t('ip')" path="ip">
        <n-input v-model:value="tableValue.ip" :placeholder="$t('message1')" readonly style="width: 200px"/>
      </n-form-item>
      <n-form-item :label="$t('device')" path="device">
        <n-select v-model:value="tableValue.device" :options="option1" style="width: 200px"/>
      </n-form-item>
      <n-form-item :label="$t('dial mode')" path="dialmode">
        <n-select v-model:value="tableValue.dialmode" :options="option2"  style="width: 200px"/>
      </n-form-item>
      <n-form-item :label="$t('ping')" path="ping">
        <n-input v-model:value="tableValue.ping" placeholder="223.5.5.5" style="width: 200px"/>
      </n-form-item>
  </n-form>
  <n-form ref="form" :model="tableValue"  label-placement="left" label-width="150px"  v-if="myflag=='1'">
      <n-form-item  :label="$t('apn')" path="apn">
        <n-input v-model:value="tableValue.apn" placeholder="apn" style="width: 200px"/>
      </n-form-item>
      <n-form-item  :label="$t('dial number')" path="dialnumber">
        <n-input v-model:value="tableValue.dialnumber" placeholder="*99#" style="width: 200px"/>
      </n-form-item>
      <n-form-item  :label="$t('verification method')" path="verification">
        <n-select v-model:value="tableValue.verification" :options="option3"  style="width: 200px"/>
      </n-form-item>
      <n-form-item  :label="$t('username')" path="username">
        <n-input v-model:value="tableValue.username" :placeholder="$t('message2')" style="width: 200px"/>
      </n-form-item>
      <n-form-item  :label="$t('password')" path="passwd">
        <n-input v-model:value="tableValue.passwd" :placeholder="$t('message2')" style="width: 200px"/>
      </n-form-item>
      <n-form-item  :label="$t('pin number')" path="pin">
        <n-input v-model:value="tableValue.pin" :placeholder="$t('message2')" style="width: 200px"/>
      </n-form-item>
 </n-form>
</template>
<script>

export default {
  data() {
    return {
      loading: false,
      myflag: '',
      value: '',
      tableValue: {
        ip: '',
        device: '',
        dialmode: '',
        ping: '',
        apn: '',
        dialnumber: '',
        verification: '',
        username: '',
        passwd: '',
        pin: ''
      },
      option1: [
        {label:'/dev/ttyS0', value:'/dev/ttyS0'},
        {label:'/dev/ttyS1', value:'/dev/ttyS1'},
        {label:'/dev/ttyS2', value:'/dev/ttyS2'},
        {label:'/dev/ttyS3', value:'/dev/ttyS3'},
        {label:'/dev/ttyS4', value:'/dev/ttyS4'},
        {label:'/dev/ttyS5', value:'/dev/ttyS5'},
        {label:'/dev/ttyS6', value:'/dev/ttyS6'}
      ],
      option2: [
        {label:'Gobinet', value:'1'},
        {label:'PPPD', value:'0'}
      ],
      option3: [
        {label:'None', value:'0'},
        {label:'Pap', value:'1'},
        {label:'Chap', value:'2'},
        {label:'MsChapV2', value:'3'}
      ]
    }
  },
  methods: {
    dialrun() {
      this.$refs.form.validate(async errors => {
        if (errors)
          return
        this.loading = true
        //1.重启模块
        await this.$oui.call('dial', 'reModem')
        //2.设置配置文件
        let apn, pincode, user, password, auth, dialnumber, apnsel, ping
        let proto, service, device, username, dev, enable
        apn = this.tableValue.apn
        pincode = this.tableValue.pin
        user = this.tableValue.username
        password = this.tableValue.passwd
        auth = this.tableValue.verification
        dialnumber = this.tableValue.dialnumber
        apnsel = this.myflag
        ping = this.tableValue.ping
        proto = '3g'
        service = 'umts'
        device = this.tableValue.device
        username = this.tableValue.username
        if (this.tableValue.dialmode === '0') {//PPPD
          dev = '3g-4g'
          enable = '0'
        } else {//Gobinet
          enable = '1'
          proto = 'dhcp'
          service = ''
          device = ''
          username = ''
        }

        this.$oui.call('uci', 'set', {
          config: 'config4g',
          section: '@4g[0]',
          values: { apn, pincode, user, password, auth, dialnumber, apnsel, ping, enable }
        })
        if (this.tableValue.dialmode === '1') {
          apn = ''
          pincode = ''
          password = ''
          dialnumber = ''
        }
        this.$oui.call('uci', 'set', {
          config: 'network',
          section: '4g',
          values: { proto, device, apn, pincode, username, dialnumber, password, service }
        })

        this.$oui.call('uci', 'set', {
          config: 'system',
          section: 'led_sys',
          values: { dev }
        })
        this.loading = false
        //重启应用
        this.$message.success(this.$t('Configuration has been applied'))
      })
    }
  },
  created() {
    //this.getroute()
    this.$oui.ubus('uci', 'get', {'config':'config4g', 'section':'@4g[0]'}).then(r => {
      this.tableValue.apn = r.values.apn
      this.tableValue.pin = r.values.pincode
      this.tableValue.passwd = r.values.password
      this.tableValue.verification = r.values.auth
      this.tableValue.dialnumber = r.values.dialnumber
      this.myflag = r.values.apnsel
      this.tableValue.ping = r.values.ping
      this.tableValue.username = r.values.user
      this.tableValue.dialmode = r.values.enable
    })
    this.$oui.ubus('uci', 'get', {'config':'network', 'section':'4g'}).then(r => {
      this.tableValue.dialnumber = r.values.dialnumber
      this.tableValue.device = r.values.device
    })

  }

}
</script>
<i18n src="./locale.json"/>
