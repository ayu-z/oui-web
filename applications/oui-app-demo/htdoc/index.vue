<template>
  <div>
    <n-h2>{{ $t('InterFace Mode') }}</n-h2>
    <n-form size="large" ref="form" label-placement="left" label-width="80px" :model="formValue" :rules="rules">
      <n-form-item :label="$t('Mode')" path="mode">
        <!-- Using Naive UI n-select -->
        <n-select :modelValue="formValue.mode" :options="modeOptions" filterable @update:value="handleModeChange" />
      </n-form-item>
    </n-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      formValue: {
        mode: '' // Set the default value here
        // ... other form fields
      },
      modeOptions: ['1-WAN N-LAN', 'Full-LAN'],
      showModeDropdown: false // Initially hide the dropdown
      // ... other data properties
    }
  },
  methods: {
    handleModeChange(value) {
      // Handle mode change if needed
      this.formValue.mode = value
    },
    fetchDataAndSetVisibility() {
      this.$oui
        .ubus('uci', 'get', { 'config': 'network', 'section': '@switch_vlan[1]' })
        .then((response) => {
          // const ports = response.values.ports
          // Update the visibility of the dropdown based on the condition
          // this.showModeDropdown = ports !== '4 5'
          // if (this.showModeDropdown) {
          // If the dropdown is visible, set the default value
          this.formValue.mode = response.values.ports
          // }
        })
        .catch((error) => {
          // Handle error if needed
          console.log(error)
        })
    }
  },
  created() {
    // Call the method to fetch data and set the visibility
    this.fetchDataAndSetVisibility()
  }
}
</script>
