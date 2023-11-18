<template>
   <n-card :title="$t('system')">
    <n-tabs default-value="l1" size="large" justify-content="space-evenly" :bar-width="28">
      <n-tab-pane name="l1" :tab="$t('system')">
        <br>
        <br>
        <n-form size="large" ref="form" label-placement="left" label-width="200px" :model="formValue">
          <n-form-item :label="$t('current system time')" path="systemtime">
            <n-input v-model:value="formValue.systemtime" style="width: 300px"/>
          </n-form-item>
          <n-form-item :label="$t('set new time')" path="newtime">
            <n-input v-model:value="formValue.newtime" style="width: 300px"/>
          </n-form-item>
        </n-form>
        <n-space style="padding-left: 445px">
          <n-button type="primary" @click="dialrun">{{ $t('save') }}</n-button>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="l2" :tab="$t('zone')">
        <br>
        <br>
        <n-form size="large" ref="form" label-placement="left" label-width="200px" :model="formValue">
          <n-form-item :label="$t('current time zone')" path="timezone">
            <n-input v-model:value="formValue.timezone" style="width: 300px"/>
          </n-form-item>
        </n-form>
        <n-space style="padding-left: 445px">
          <n-button type="primary" @click="dialrun">{{ $t('save') }}</n-button>
        </n-space>
      </n-tab-pane>

    </n-tabs>
  </n-card>
</template>

<script>

export default {
  data() {
    return {
      formValue: {
        systemtime: '',
        newtime: '',
        timezone: ''
      }
    }
  },
  methods: {
    //添加规则空白项
    getlogger() {
      this.$oui.call('log', 'getlog', {cmd: this.cmd1}).then(({ value }) => {
        this.value1 = value
      })

      this.$oui.call('log', 'getlog', {cmd: this.cmd2}).then(({ value }) => {
        this.value2 = value
      })
    }
  },
  created() {
    //this.getlogger()//获取规则列表
  }
}
</script>
<style>
  #textarea {
              width: 100%;
              height: 1400px;
            }
</style>
<i18n src="./locale.json"/>

