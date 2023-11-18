<template>
  <div>
    <div>
      <n-h2>{{ $t('InterFace Mode') }}</n-h2>
      <n-form size="large" ref="form" label-placement="left" label-width="auto" :model="formValue" :rules="rules">
        <n-form-item :label="$t('Mode')" path="mode">
          <n-select v-model="formValue.mode" :options="transmode" filterable @change="handlemodeChange" />
        </n-form-item>
      </n-form>
    </div>

    <div v-if="showWANSetting">
      <n-h2>{{ $t('WAN Setting') }}</n-h2>
    </div>

    <div>
      <n-h2>{{ $t('LAN Setting') }}</n-h2>
      <n-form size="large" ref="form" label-placement="left" label-width="auto" :model="formValue" :rules="rules">
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
          mode: '',
          pppoe :{
            user:'',
            passwd:''
          },
          static :{
            ipaddr:'',
            gateway:''
          }
        },
        lan: {
          ipaddr: '',
          netmask: ''
        }
      },
      mode: ['1-WAN N-LAN', 'Full-LAN'],
      showWANSetting: false,
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
    transmode() {
      return this.mode.map((option) => ({
        value: option,
        label: this.$t(option)
      }))
    }
  },
  created() {
    this.$oui.ubus('uci', 'get', { 'config': 'network', 'section': 'lan' })
      .then(r => {
        this.formValue.lan.ipaddr = r.values.ipaddr,
        this.formValue.lan.netmask = r.values.netmask
      })
  },
  methods: {
    handlemodeChange(selectedOption) {
      this.showWANSetting = (selectedOption === '1-WAN N-LAN')
    },
    handleSubmit() {
      // Add your form submission logic here
    }
  }
}
</script>

<i18n src="./locale.json"/>
