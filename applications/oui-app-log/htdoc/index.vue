<template>
  <n-card :title="$t('system')">
    <n-tabs default-value="l1" size="large" justify-content="space-evenly">
      <n-tab-pane name="l1" :tab="$t('log1')">
        <br>
        <n-form ref="form" :model="tableValue"  label-placement="left" label-width="150px">
          <n-form-item >
            <n-input id=textarea :value="value1" type="textarea" readonly placeholder="" />
          </n-form-item>
        </n-form>
        <br>
      </n-tab-pane>

      <n-tab-pane name="l2" :tab="$t('log2')">
        <br>
        <n-form ref="form" :model="tableValue"  label-placement="left" label-width="150px">
          <n-form-item >
            <n-input id=textarea :value="value2" type="textarea" readonly placeholder="" />
          </n-form-item>
        </n-form>
        <br>
      </n-tab-pane>

    </n-tabs>
  </n-card>
</template>
<script>

export default {
  data() {
    return {
      value1: '',
      value2: '',
      cmd1: 'dmesg',
      cmd2: 'logread'
    }
  },
  methods: {
    //添加规则空白项
    getlogger() {
      this.$oui.call('log', 'getlog').then(({ v }) => {
        this.value1 = v
      })
    }
  },
  created() {
    this.getlogger()
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

