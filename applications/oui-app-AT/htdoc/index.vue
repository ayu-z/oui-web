<template>
    <br>
    <n-space style="padding-left: 150px">
          <n-button type="primary"  @click="saveconfig">{{ $t('run') }}</n-button>
    </n-space>
    <br>
    <n-form ref="form" :model="tableValue"  label-placement="left" label-width="150px">
			<n-form-item :label="$t('device')" path="tty">
        <n-select v-model:value="tableValue.tty" :options="option" style="width: 200px"/>
      </n-form-item>
      <n-form-item :label="$t('cmd')" path="cmd">
				<n-input v-model:value="tableValue.cmd" placeholder="AT+BNDLOCK=5.0" style="width: 200px"/>
			</n-form-item>
      <n-form-item :label="$t('result')" >
				<n-input id=textarea :value="value" type="textarea" readonly placeholder="" />
			</n-form-item>
		</n-form>
    <br>

</template>
<script>

export default {
  data() {
    return {
      value: '',
      tableValue: {
        tty: '',
        cmd: ''
      },
      option: [
        {label:'/dev/ttyS0', value:'/dev/ttyS0'},
        {label:'/dev/ttyS1', value:'/dev/ttyS1'},
        {label:'/dev/ttyS2', value:'/dev/ttyS2'},
        {label:'/dev/ttyS3', value:'/dev/ttyS3'},
        {label:'/dev/ttyS4', value:'/dev/ttyS4'},
        {label:'/dev/ttyS5', value:'/dev/ttyS5'},
        {label:'/dev/ttyS6', value:'/dev/ttyS6'}
      ]
    }
  },

  methods: {
    getdev() {
      this.$oui.call('at', 'getdev').then(({option}) => {
        this.option = option
      })
    },

    saveconfig() {
      let device = this.tableValue.tty
      this.$oui.call('uci', 'set', {
        config: 'tty',
        section: 'dev',
        values: { device }
      })
      this.$message.success(this.$t('Configuration has been applied'))
    }
  },

  created() {
    //this.getdev()
    this.$oui.call('uci', 'get', {
      config: 'tty',
      section: 'dev',
      option: 'device'
    }).then(device => {
      this.tableValue.tty = device
    })
  }
}
</script>

<style>
  #textarea {
              width: 600px;
              height: 400px;
            }
</style>
<i18n src="./locale.json"/>