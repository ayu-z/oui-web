<template>
<n-card :title="$t('dmz')">
  <br>
  <br>
  <n-form size="large" ref="form" label-placement="left" label-width="150px" :model="formValue">
    <n-form-item :label="$t('ip')" path="ip">
			<n-input v-model:value="formValue.ip" style="width: 200px"/>
		</n-form-item>
  </n-form>
   <n-space style="padding-left: 295px">
          <n-button type="primary" @click="dialrun">{{ $t('save') }}</n-button>
  </n-space>
</n-card>
</template>
<script>
export default {
  data() {
    return {
      formValue: {
        ip: ''
      }
    }
  }
}
</script>
<i18n src="./locale.json"/>
