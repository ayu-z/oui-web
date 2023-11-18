<template>
<n-card :title="$t('wan')">
  <br>
  <n-space style="padding-left: 150px">
          <n-button type="primary" @click="dialrun">{{ $t('save') }}</n-button>
  </n-space>
  <br>
  <n-form size="large" ref="form" label-placement="left" label-width="150px" :model="formValue">
		<n-form-item :label="$t('internet mode')" path="mode">
			<n-select v-model:value="formValue.mode" :options="option" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('wan priority')" path="wan">
			<n-input v-model:value="formValue.wan" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('lte priority')" path="lte">
			<n-input v-model:value="formValue.lte" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('wwan priority')" path="wwan">
			<n-input v-model:value="formValue.wwan" style="width: 200px"/>
		</n-form-item>
  </n-form>
</n-card>
</template>
<script>
export default {
  data() {
    return {
      formValue: {
        mode: '1',
        wan: '',
        lte: '',
        wwan: ''
      },
      option: [
        {label:'静态IP', value:'0'},
        {label:'PPPOE拨号', value:'1'},
        {label:'获取动态IP', value:'2'},
        {label:'WAN2LAN', value:'3'}
      ]
    }
  }
}
</script>
<i18n src="./locale.json"/>

